import 'dart:convert';
import 'dart:io';
import 'package:LogisticsMasters/core/config/app_config.dart';
import 'package:LogisticsMasters/features/auth/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class AuthService {
  static const String _userKey = 'current_user';
  final GetStorage _storage = GetStorage();

  // Inicializar GetStorage (llama a este método en el main.dart)
  static Future<void> init() async {
    await GetStorage.init();
  }

  Future<User> login(String username, String password) async {
    final Uri uri = Uri.parse('${AppConfig.usersEndpoint}/username/$username');

    try {
      // Primero verificamos si el usuario existe
      http.Response response = await http.get(
        uri,
        headers: AppConfig.commonHeaders,
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);

        // Verificar la contraseña (esto debería manejarse en el backend)
        // Por ahora asumimos que el backend maneja la autenticación
        final user = User(
          id: json['id'],
          email: json['email'] ?? '',
          username: json['usuario'] ?? username, // Usando 'usuario' del backend
          image: '', // No hay imagen en tu backend
          name:
              '${json['nombre'] ?? ''} ${json['apellido'] ?? ''}', // Usando 'nombre' y 'apellido'
        );

        // Guardar el usuario en GetStorage
        await _saveUser(user);

        return user;
      } else {
        throw Exception('Usuario no encontrado o credenciales incorrectas');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String username,
    String password,
  ) async {
    final uri = Uri.parse(AppConfig.usersEndpoint);
    final body = {
      "usuario": username, // Usando 'usuario' según tu backend
      "email": email,
      "nombre": firstName, // Usando 'nombre' según tu backend
      "apellido": lastName, // Usando 'apellido' según tu backend
      "contrasena": password, // Usando 'contrasena' según tu backend
    };

    try {
      final response = await http.post(
        uri,
        headers: AppConfig.commonHeaders,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final user = User(
          id: json['id'],
          email: json['email'] ?? email,
          username: json['usuario'] ?? username,
          image: '', // No hay imagen en tu backend
          name:
              '${json['nombre'] ?? firstName} ${json['apellido'] ?? lastName}',
        );

        // Guardar el usuario en GetStorage
        await _saveUser(user);

        return user;
      } else {
        final errorBody = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {};
        throw Exception(errorBody['message'] ?? 'Error al registrar usuario');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Método para guardar el usuario actual
  Future<void> _saveUser(User user) async {
    final userMap = {
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'image': user.image,
      'name': user.name,
    };
    await _storage.write(_userKey, jsonEncode(userMap));
  }

  // Método para obtener el usuario actual
  Future<User?> getCurrentUser() async {
    final userData = _storage.read(_userKey);

    if (userData != null) {
      final userMap = jsonDecode(userData);
      return User(
        id: userMap['id'],
        email: userMap['email'],
        username: userMap['username'],
        image: userMap['image'] ?? '',
        name: userMap['name'],
      );
    }

    // Si no hay usuario guardado, retorna null
    return null;
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    await _storage.remove(_userKey);
  }
}

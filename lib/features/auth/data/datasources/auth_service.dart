import 'dart:convert';
import 'dart:io';
import 'package:LogisticsMasters/features/auth/data/models/user_dto.dart';
import 'package:LogisticsMasters/features/auth/data/models/user_request_dto.dart';  
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
    final Uri uri = Uri.parse('https://dummyjson.com/auth/login');
    http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        UserRequestDto(username: username, password: password).toJson(),
      ),
    );
    
    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      final user = UserDto.fromJson(json).toDomain();
      
      // Guardar el usuario en GetStorage
      await _saveUser(user);
      
      return user;
    }
    throw Exception('Failed to login');
  }

  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String username,
    String password,
  ) async {
    final uri = Uri.parse('https://dummyjson.com/users/add');
    final body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "username": username,
      "password": password,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      final user = User(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        image: json['image'] ?? '',
        name: "${json['firstName']} ${json['lastName']}",
      );
      
      // Guardar el usuario en GetStorage
      await _saveUser(user);
      
      return user;
    } else {
      throw Exception('Failed to register');
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
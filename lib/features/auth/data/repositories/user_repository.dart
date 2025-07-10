import 'package:get_storage/get_storage.dart';
import 'package:LogisticsMasters/features/auth/domain/entities/user.dart';

class UserRepository {
  static const String _currentUserKey = 'current_user';
  final GetStorage _storage = GetStorage();
  
  // Inicializar GetStorage
  static Future<void> init() async {
    await GetStorage.init();
  }
  
  // Guardar usuario
  Future<void> saveUser(User user) async {
    await _storage.write(_currentUserKey, {
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'image': user.image,
      'name': user.name,
    });
  }
  
  // Obtener usuario actual
  Future<User?> getCurrentUser() async {
    final userData = _storage.read(_currentUserKey);
    
    if (userData != null) {
      return User(
        id: userData['id'],
        email: userData['email'],
        username: userData['username'],
        image: userData['image'] ?? '',
        name: userData['name'],
      );
    }
    
    return null;
  }
  
  // Cerrar sesión
  Future<void> logout() async {
    await _storage.remove(_currentUserKey);
  }
}
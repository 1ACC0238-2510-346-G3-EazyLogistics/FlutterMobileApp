import 'dart:convert';
import 'dart:io';
import 'package:LogisticsMasters/features/auth/data/models/user_dto.dart';
import 'package:LogisticsMasters/features/auth/data/models/user_request_dto.dart';  
import 'package:LogisticsMasters/features/auth/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
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
        return UserDto.fromJson(json).toDomain();
      }
      throw Exception('Failed to login');
    
  }
}
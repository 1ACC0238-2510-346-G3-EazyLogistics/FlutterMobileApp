import 'package:LogisticsMasters/features/auth/domain/entities/user.dart';

class UserDto {
  final int id;
  final String email;
  final String username;
  final String image;
  final String firstName;
  final String lastName;

  const UserDto({
    required this.id,
    required this.email,
    required this.username,
    required this.image,
    required this.firstName,
    required this.lastName,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {

    return UserDto(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      image: json['image'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  User toDomain() {
    return User(
      id: id,
      email: email,
      username: username,
      image: image,
      name: '$firstName $lastName',
    );
  }
}
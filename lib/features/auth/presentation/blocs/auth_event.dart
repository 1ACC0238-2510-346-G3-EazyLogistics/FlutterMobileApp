abstract class AuthEvent {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  final String username;
  final String password;

  const SignInEvent({required this.username, required this.password});
}
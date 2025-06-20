import 'package:LogisticsMasters/features/auth/domain/entities/user.dart';

abstract class AuthState {
  const AuthState();
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class SuccessAuthState extends AuthState {
  final User user;
  const SuccessAuthState({required this.user});
}

class FailureAuthState extends AuthState {
  final String errorMessage;
  const FailureAuthState({required this.errorMessage});
}
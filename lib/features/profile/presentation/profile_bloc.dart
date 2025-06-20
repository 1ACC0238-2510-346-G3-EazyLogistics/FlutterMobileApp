import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  const UpdateProfile({required this.name, required this.email});
  @override
  List<Object?> get props => [name, email];
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final String name;
  final String email;
  const ProfileUpdated({required this.name, required this.email});
  @override
  List<Object?> get props => [name, email];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<UpdateProfile>((event, emit) {
      emit(ProfileUpdated(name: event.name, email: event.email));
    });
  }
}

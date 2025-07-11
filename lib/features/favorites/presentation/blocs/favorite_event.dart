import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class AddFavoriteEvent extends FavoriteEvent {
  final FavoriteHotel favoriteHotel;
  final String? userId;

  const AddFavoriteEvent({required this.favoriteHotel, this.userId});

  @override
  List<Object?> get props => [favoriteHotel, userId];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String id;
  final String? userId;

  const RemoveFavoriteEvent({required this.id, this.userId});

  @override
  List<Object?> get props => [id, userId];
}

class GetAllFavoriteEvent extends FavoriteEvent {
  final String? userId;

  const GetAllFavoriteEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class CheckIsFavoriteEvent extends FavoriteEvent {
  final String id;
  final String? userId;

  const CheckIsFavoriteEvent({required this.id, this.userId});

  @override
  List<Object?> get props => [id, userId];
}

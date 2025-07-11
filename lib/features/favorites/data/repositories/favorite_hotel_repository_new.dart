import 'package:LogisticsMasters/features/favorites/data/datasources/favorite_hotel_service.dart';
import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';

class FavoriteHotelRepository {
  final FavoriteHotelService _service = FavoriteHotelService();

  // Usar solo backend
  Future<void> insertFavoriteHotel(
    FavoriteHotel favoriteHotel,
    String userId,
  ) async {
    await _service.addToFavorites(
      userId,
      favoriteHotel.id,
      favoriteHotel.name,
      favoriteHotel.imageUrl,
      favoriteHotel.city,
      favoriteHotel.rating,
      favoriteHotel.pricePerNight.toDouble(),
    );
  }

  Future<void> deleteFavoriteHotel(String id, String userId) async {
    // Primero buscar el favorito en el backend
    final favorite = await _service.getFavoriteByHotelId(userId, id);
    if (favorite != null) {
      await _service.removeFromFavorites(favorite.id);
    }
  }

  Future<List<FavoriteHotel>> getAllFavoriteHotels(String userId) async {
    return await _service.getUserFavorites(userId);
  }

  Future<bool> isFavorite(String id, String userId) async {
    return await _service.isFavorite(userId, id);
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:LogisticsMasters/core/config/app_config.dart';
import 'package:LogisticsMasters/features/favorites/data/models/favorite_hotel_dto.dart';
import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:http/http.dart' as http;

class FavoriteHotelService {
  // Obtener todos los favoritos de un usuario
  Future<List<FavoriteHotel>> getUserFavorites(String userId) async {
    final Uri uri = Uri.parse('${AppConfig.usersEndpoint}/$userId/favorites');

    try {
      final response = await http
          .get(uri, headers: AppConfig.commonHeaders)
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => FavoriteHotelDto.fromJson(json).toDomain())
            .toList();
      }

      throw Exception('Failed to load favorites: ${response.statusCode}');
    } catch (e) {
      if (AppConfig.debugMode) {
        print("Error in getUserFavorites: $e");
      }
      throw Exception('Error loading favorites: $e');
    }
  }

  // Agregar un hotel a favoritos
  Future<FavoriteHotel> addToFavorites(
    String userId,
    String hotelId,
    String hotelName,
    String hotelImage,
    String hotelLocation,
    double hotelRating,
    double hotelPrice,
  ) async {
    final Uri uri = Uri.parse('${AppConfig.usersEndpoint}/$userId/favorites');

    try {
      final data = {
        'userId': int.parse(userId),
        'hotelId': int.parse(hotelId),
        'hotelName': hotelName,
        'hotelImage': hotelImage,
        'hotelLocation': hotelLocation,
        'hotelRating': hotelRating,
        'hotelPrice': hotelPrice,
      };

      if (AppConfig.debugMode) {
        print("Adding to favorites: $data");
      }

      final response = await http
          .post(uri, headers: AppConfig.commonHeaders, body: jsonEncode(data))
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final json = jsonDecode(response.body);
        return FavoriteHotelDto.fromJson(json).toDomain();
      } else {
        throw Exception('Error adding to favorites: ${response.statusCode}');
      }
    } catch (e) {
      if (AppConfig.debugMode) {
        print("Error in addToFavorites: $e");
      }
      throw Exception('Error adding to favorites: $e');
    }
  }

  // Eliminar un hotel de favoritos
  Future<void> removeFromFavorites(String userId, String favoriteId) async {
    final Uri uri = Uri.parse(
      '${AppConfig.usersEndpoint}/$userId/favorites/$favoriteId',
    );

    try {
      final response = await http
          .delete(uri, headers: AppConfig.commonHeaders)
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode != HttpStatus.ok &&
          response.statusCode != HttpStatus.noContent) {
        throw Exception(
          'Error removing from favorites: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (AppConfig.debugMode) {
        print("Error in removeFromFavorites: $e");
      }
      throw Exception('Error removing from favorites: $e');
    }
  }

  // Verificar si un hotel está en favoritos
  Future<bool> isFavorite(String userId, String hotelId) async {
    final Uri uri = Uri.parse('${AppConfig.usersEndpoint}/$userId/favorites');

    try {
      final response = await http
          .get(uri, headers: AppConfig.commonHeaders)
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.any(
          (favorite) => favorite['hotelId'].toString() == hotelId,
        );
      }

      return false;
    } catch (e) {
      if (AppConfig.debugMode) {
        print("Error in isFavorite: $e");
      }
      return false;
    }
  }

  // Obtener un favorito específico por userId y hotelId
  Future<FavoriteHotel?> getFavoriteByHotelId(
    String userId,
    String hotelId,
  ) async {
    final Uri uri = Uri.parse('${AppConfig.usersEndpoint}/$userId/favorites');

    try {
      final response = await http
          .get(uri, headers: AppConfig.commonHeaders)
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final favoriteJson = jsonList.firstWhere(
          (favorite) => favorite['hotelId'].toString() == hotelId,
          orElse: () => null,
        );

        if (favoriteJson != null) {
          return FavoriteHotelDto.fromJson(favoriteJson).toDomain();
        }
      }

      return null;
    } catch (e) {
      if (AppConfig.debugMode) {
        print("Error in getFavoriteByHotelId: $e");
      }
      return null;
    }
  }
}

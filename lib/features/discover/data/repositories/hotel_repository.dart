import 'package:LogisticsMasters/features/discover/data/datasources/hotel_service.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';

class HotelRepository {
  final HotelService _service = HotelService();

  // Obtener todos los hoteles
  Future<List<Hotel>> getHotels() async {
    try {
      return await _service.fetchHotels();
    } catch (e) {
      print('Error getting hotels: $e');
      return [];
    }
  }

  // Obtener hoteles populares
  Future<List<Hotel>> getPopularHotels() async {
    try {
      final hotels = await _service.fetchHotels();
      return hotels
          .where((hotel) => hotel.popularity >= 4)
          .toList()
        ..sort((a, b) => b.popularity.compareTo(a.popularity));
    } catch (e) {
      print('Error getting popular hotels: $e');
      return [];
    }
  }

  // Obtener hoteles recomendados
  Future<List<Hotel>> getRecommendedHotels() async {
    try {
      final hotels = await _service.fetchHotels();
      return hotels
          .where((hotel) => hotel.rating >= 4.5)
          .toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));
    } catch (e) {
      print('Error getting recommended hotels: $e');
      return [];
    }
  }

  // Obtener un hotel por su ID
  Future<Hotel?> getHotelById(String id) async {
    try {
      final allHotels = await _service.fetchHotels();
      return allHotels.firstWhere(
        (hotel) => hotel.id == id,
        orElse: () => throw Exception('Hotel not found'),
      );
    } catch (e) {
      print('Error getting hotel by ID: $e');
      return null;
    }
  }

  // Buscar hoteles por texto
  Future<List<Hotel>> searchHotels(String query) async {
    try {
      final hotels = await _service.fetchHotels();
      final lowercaseQuery = query.toLowerCase();
      
      return hotels.where((hotel) {
        return hotel.name.toLowerCase().contains(lowercaseQuery) ||
               hotel.city.toLowerCase().contains(lowercaseQuery) ||
               hotel.country.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      print('Error searching hotels: $e');
      return [];
    }
  }
}
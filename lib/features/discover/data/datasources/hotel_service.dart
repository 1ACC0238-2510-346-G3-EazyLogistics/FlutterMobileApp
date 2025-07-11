import 'dart:convert';
import 'dart:io';
import 'package:LogisticsMasters/core/config/app_config.dart';
import 'package:LogisticsMasters/features/discover/data/models/hotel_dto.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:http/http.dart' as http;

class HotelService {
  // Obtener todos los hoteles
  Future<List<Hotel>> fetchHotels() async {
    final Uri uri = Uri.parse(AppConfig.hotelsEndpoint);

    try {
      http.Response response = await http
          .get(uri, headers: AppConfig.commonHeaders)
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode == HttpStatus.ok) {
        List maps = jsonDecode(response.body);
        return maps.map((e) => HotelDto.fromJson(e).toDomain()).toList();
      } else {
        throw Exception('Error obteniendo hoteles: ${response.statusCode}');
      }
    } catch (e) {
      if (AppConfig.debugMode) {
        print('Error en HotelService.fetchHotels(): $e');
      }
      throw Exception('Error conectando al servidor: $e');
    }
  }

  // Obtener hotel por ID
  Future<Hotel> getHotelById(int hotelId) async {
    final Uri uri = Uri.parse('${AppConfig.hotelsEndpoint}/$hotelId');

    try {
      http.Response response = await http
          .get(uri, headers: AppConfig.commonHeaders)
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return HotelDto.fromJson(json).toDomain();
      } else {
        throw Exception('Hotel no encontrado');
      }
    } catch (e) {
      if (AppConfig.debugMode) {
        print('Error en HotelService.getHotelById(): $e');
      }
      throw Exception('Error conectando al servidor: $e');
    }
  }

  // Buscar hoteles por ciudad
  Future<List<Hotel>> searchHotelsByCity(String city) async {
    final Uri uri = Uri.parse('${AppConfig.hotelsEndpoint}/ciudad/$city');

    try {
      http.Response response = await http
          .get(uri, headers: AppConfig.commonHeaders)
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode == HttpStatus.ok) {
        List maps = jsonDecode(response.body);
        return maps.map((e) => HotelDto.fromJson(e).toDomain()).toList();
      } else {
        return []; // Sin resultados
      }
    } catch (e) {
      if (AppConfig.debugMode) {
        print('Error en HotelService.searchHotelsByCity(): $e');
      }
      return []; // Devolver lista vacía en caso de error
    }
  }

  // Buscar hoteles por nombre
  Future<List<Hotel>> searchHotelsByName(String name) async {
    final Uri uri = Uri.parse('${AppConfig.hotelsEndpoint}/nombre/$name');

    try {
      http.Response response = await http
          .get(uri, headers: AppConfig.commonHeaders)
          .timeout(Duration(seconds: AppConfig.httpTimeoutSeconds));

      if (response.statusCode == HttpStatus.ok) {
        List maps = jsonDecode(response.body);
        return maps.map((e) => HotelDto.fromJson(e).toDomain()).toList();
      } else {
        return []; // Sin resultados
      }
    } catch (e) {
      if (AppConfig.debugMode) {
        print('Error en HotelService.searchHotelsByName(): $e');
      }
      return []; // Devolver lista vacía en caso de error
    }
  }
}

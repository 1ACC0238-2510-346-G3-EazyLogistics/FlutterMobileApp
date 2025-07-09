import 'dart:convert';
import 'dart:io';
import 'package:LogisticsMasters/features/bookings/data/book_item_dto.dart';
import 'package:LogisticsMasters/features/bookings/data/book_item_request_dto.dart';
import 'package:LogisticsMasters/features/bookings/domain/book_item.dart';
import 'package:http/http.dart' as http;

class BookItemService {
  final String baseUrl = 'https://logisticsmasters.onrender.com';

  // Crear una nueva reserva
  Future<BookItem> createBooking(BookItem booking, String userId) async {
    final Uri uri = Uri.parse('$baseUrl/bookings');
    
    try {
      final requestDto = BookItemRequestDto.fromDomain(booking, userId);
      final jsonData = requestDto.toJson();
      
      print("Sending booking data: $jsonData");
      
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );
      
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      
      if (response.statusCode == HttpStatus.created || 
          response.statusCode == HttpStatus.ok) {
        
        // Si la respuesta está vacía o no es un JSON válido, usar los datos enviados
        if (response.body.isEmpty) {
          print("Empty response, creating BookItem from request data");
          // Generar un ID temporal si el servidor no lo devuelve
          return booking;
        }
        
        try {
          final json = jsonDecode(response.body);
          // Asegurarse de que el ID sea un string
          if (json['id'] != null && json['id'] is int) {
            json['id'] = json['id'].toString();
          }
          return BookItemDto.fromJson(json).toDomain();
        } catch (parseError) {
          print("Error parsing response: $parseError");
          // Si hay un error al procesar la respuesta, usar los datos originales
          return booking;
        }
      }
      
      throw Exception('Failed to create booking: ${response.statusCode}');
    } catch (e) {
      print("Exception in createBooking: $e");
      
      // Si la excepción ocurrió después de crear exitosamente la reserva,
      // pero hubo un problema al procesar la respuesta, devolver el objeto original
      if (e.toString().contains("type 'int' is not a subtype of type 'String'")) {
        print("Type error detected but booking likely created. Returning original booking.");
        return booking;
      }
      
      throw Exception('Error creating booking: $e');
    }
  }

  // Obtener todas las reservas de un usuario
  Future<List<BookItem>> getUserBookings(String userId) async {
    final Uri uri = Uri.parse('$baseUrl/bookings?userId=$userId');
    
    try {
      final response = await http.get(uri);
      
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => BookItemDto.fromJson(json).toDomain())
            .toList();
      }
      throw Exception('Failed to get user bookings: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
  }

  // Obtener una reserva específica
  Future<BookItem> getBooking(String bookingId) async {
    final Uri uri = Uri.parse('$baseUrl/bookings/$bookingId');
    
    try {
      final response = await http.get(uri);
      
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return BookItemDto.fromJson(json).toDomain();
      }
      throw Exception('Failed to get booking: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching booking: $e');
    }
  }

  // Cancelar una reserva
  Future<BookItem> cancelBooking(String bookingId) async {
    final Uri uri = Uri.parse('$baseUrl/bookings/$bookingId');
    
    try {
      // Primero obtenemos la reserva actual
      final getResponse = await http.get(uri);
      
      if (getResponse.statusCode == HttpStatus.ok) {
        final currentBooking = jsonDecode(getResponse.body);
        
        // Actualizamos solo el estado a "cancelled"
        currentBooking['status'] = 'cancelled';
        
        final updateResponse = await http.put(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(currentBooking),
        );
        
        if (updateResponse.statusCode == HttpStatus.ok) {
          final json = jsonDecode(updateResponse.body);
          return BookItemDto.fromJson(json).toDomain();
        }
      }
      throw Exception('Failed to cancel booking: ${getResponse.statusCode}');
    } catch (e) {
      throw Exception('Error cancelling booking: $e');
    }
  }
}
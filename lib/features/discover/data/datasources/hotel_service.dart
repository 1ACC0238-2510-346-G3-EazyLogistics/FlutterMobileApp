import 'dart:convert';
import 'dart:io';

import 'package:LogisticsMasters/features/discover/data/models/hotel_dto.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:http/http.dart' as http;

class HotelService {
  Future<List<Hotel>> fetchHotels() async {
    final Uri uri = Uri.parse('https://logisticsmasters.onrender.com/hotels');
    http.Response response = await http.get(uri);
    if (response.statusCode == HttpStatus.ok) {
      List maps = jsonDecode(response.body);
      return maps.map((e) => HotelDto.fromJson(e).toDomain()).toList();
    }
    return [];
  }

}
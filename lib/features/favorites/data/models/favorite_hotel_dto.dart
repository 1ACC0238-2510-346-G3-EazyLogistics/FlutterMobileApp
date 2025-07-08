import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';

class FavoriteHotelDto {
  final String id;
  final String name;
  final String imageUrl;
  final int pricePerNight;
  final String country;
  final String city;
  final double rating;

  const FavoriteHotelDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    required this.country,
    required this.city,
  });

  factory FavoriteHotelDto.fromDomain(FavoriteHotel hotel) {
    return FavoriteHotelDto(
      id: hotel.id,
      name: hotel.name,
      imageUrl: hotel.imageUrl,
      rating: hotel.rating,
      pricePerNight: hotel.pricePerNight,
      country: hotel.country,
      city: hotel.city,
    );
  }

  FavoriteHotel toDomain() {
    return FavoriteHotel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      rating: rating,
      pricePerNight: pricePerNight,
      country: country,
      city: city,
    );
  }

  factory FavoriteHotelDto.fromMap(Map<String, dynamic> map) {
    return FavoriteHotelDto(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      rating: (map['rating'] as num).toDouble(),
      pricePerNight: map['pricePerNight'] as int,
      country: map['country'] as String,
      city: map['city'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'pricePerNight': pricePerNight,
      'country': country,
      'city': city,
    };
  }
}
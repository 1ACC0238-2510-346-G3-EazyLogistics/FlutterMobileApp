import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';

class FavoriteHotel {
  final String id;
  final String name;
  final String imageUrl;
  final int pricePerNight;
  final String country;
  final String city;
  final double rating;

  FavoriteHotel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    required this.country,
    required this.city,
  });

  Hotel toHotel() {
    return Hotel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      rating: rating,
      pricePerNight: pricePerNight,
      country: country,
      city: city,
      description: "",
      popularity: 0,
      reviews: [],
      cityImageUrl: "",
    );
  }
}


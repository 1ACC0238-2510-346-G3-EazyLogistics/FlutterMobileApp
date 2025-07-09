import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';

class HotelDto {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int pricePerNight;
  final String country;
  final String city;
  final String cityImageUrl;
  final int popularity;
  final List<HotelReviewDto> reviews;


  const HotelDto({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    required this.country,
    required this.city,
    required this.cityImageUrl,
    required this.popularity,
    required this.reviews,
  });

  factory HotelDto.fromJson(Map<String, dynamic> json) {
    return HotelDto(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      pricePerNight: json['pricePerNight'] as int? ?? 0,
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      cityImageUrl: json['cityImageUrl'] as String? ?? '',
      popularity: json['popularity'] as int? ?? 0,
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => HotelReviewDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Hotel toDomain() {
    return Hotel(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      pricePerNight: pricePerNight,
      country: country,
      city: city,
      cityImageUrl: cityImageUrl,
      popularity: popularity,
      reviews: reviews.map((review) => review.toDomain()).toList(),
    );
  }
}

class HotelReviewDto {
  final String username;
  final String comment;
  final int rating;
  final String profilePicture;
  final String ratingDate;

  const HotelReviewDto({
    required this.username,
    required this.comment,
    required this.rating,
    required this.profilePicture,
    required this.ratingDate,
  });

  factory HotelReviewDto.fromJson(Map<String, dynamic> json) {
    return HotelReviewDto(
      username: json['userName'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      profilePicture: json['profilePicture'] as String? ?? 'https://randomuser.me/api/portraits/lego/1.jpg',
      ratingDate: json['ratingDate'] as String? ?? '',
    );
  }

  HotelReview toDomain() {
    return HotelReview(
      username: username,
      comment: comment,
      rating: rating,
      profilePicture: profilePicture,
      ratingDate: ratingDate,
    );
  }
}
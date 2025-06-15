import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';

class HotelDto {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int pricePerNight;
  final List<HotelReviewDto> reviews;


  const HotelDto({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    required this.reviews,
  });

  factory HotelDto.fromJson(Map<String, dynamic> json) {
    return HotelDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      pricePerNight: json['pricePerNight'] as int,
      reviews: (json['reviews'] as List)
          .map((size) => HotelReviewDto.fromJson(size as Map<String, dynamic>))
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
      reviews: reviews.map((review) => review.toDomain()).toList(),
    );
  }
}

class HotelReviewDto {
    final String username;
    final String comment;
    final double rating;

const HotelReviewDto({
      required this.username,
      required this.comment,
      required this.rating,
    });

    factory HotelReviewDto.fromJson(Map<String, dynamic> json) {
      return HotelReviewDto(
        username: json['username'] as String,
        comment: json['comment'] as String,
        rating: (json['rating'] as num).toDouble(),
      );
    }

    HotelReview toDomain() {
      return HotelReview(
        username: username,
        comment: comment,
        rating: rating,
      );
    }
  }
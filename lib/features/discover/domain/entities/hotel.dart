class Hotel {
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
  final List<HotelReview> reviews;

  Hotel({
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
}

class HotelReview {
  final String username;
  final String comment;
  final int rating;
  final String profilePicture;
  final String ratingDate;

  HotelReview({
    required this.username,
    required this.comment,
    required this.rating,
    required this.profilePicture,
    required this.ratingDate,
  });
}
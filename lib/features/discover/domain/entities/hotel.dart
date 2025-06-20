class Hotel{
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int pricePerNight;
  final List<HotelReview> reviews;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    required this.reviews,
  });
}

class HotelReview {
  final String username;
  final String comment;
  final double rating;

  HotelReview({
    required this.username,
    required this.comment,
    required this.rating,
  });
}
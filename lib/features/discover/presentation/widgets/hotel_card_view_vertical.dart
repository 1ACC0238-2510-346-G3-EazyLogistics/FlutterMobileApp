import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:flutter/material.dart';

class HotelCardViewVertical extends StatelessWidget {
  final Hotel hotel;
  final double imageWidth;
  final double imageHeight;

  const HotelCardViewVertical({
    super.key,
    required this.hotel,
    this.imageWidth = 240,
    this.imageHeight = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    hotel.imageUrl,
                    height: imageHeight,
                    width: imageWidth,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Stars
                  ...List.generate(
                    hotel.rating.floor(),
                    (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
                  ),
                  if (hotel.rating - hotel.rating.floor() >= 0.5)
                    const Icon(Icons.star_half, color: Colors.amber, size: 20),
                  ...List.generate(
                    5 - hotel.rating.ceil(),
                    (index) => const Icon(Icons.star_border, color: Colors.amber, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hotel.rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " (${hotel.reviews.length} Reviews)",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                hotel.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "${hotel.city}, ${hotel.country}",
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$${hotel.pricePerNight}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: "/night",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
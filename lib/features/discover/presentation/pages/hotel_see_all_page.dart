import 'package:LogisticsMasters/features/discover/presentation/pages/hotel_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import '../widgets/hotel_card_view_vertical.dart';
import '../widgets/hotel_card_view_horizontal.dart';
import 'package:LogisticsMasters/features/discover/data/models/card_type.dart';

class HotelSeeAllPage extends StatelessWidget {
  final List<Hotel> hotels;
  final CardType cardType;
  final String title;

  const HotelSeeAllPage({
    super.key,
    required this.hotels,
    required this.cardType,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          if (cardType == CardType.vertical) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetailPage(hotel: hotel),
                    ),
                  );
                },
                child: HotelCardViewVertical(
                  hotel: hotel,
                  imageWidth: 340,
                  imageHeight: 160,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetailPage(hotel: hotel),
                    ),
                  );
                },
                child: HotelCardViewHorizontal(hotel: hotel),
              ),
            );
          }
        },
      ),
    );
  }
}
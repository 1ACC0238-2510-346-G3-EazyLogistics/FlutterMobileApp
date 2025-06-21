import 'package:flutter/material.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'hotel_card_view_horizontal.dart';
import 'package:LogisticsMasters/features/discover/presentation/pages/hotel_detail_page.dart';

class HotelListViewHorizontal extends StatelessWidget {
  final List<Hotel> hotels;
  const HotelListViewHorizontal({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    final filteredHotels = hotels.where((hotel) => hotel.rating > 4.6).toList();

    if (filteredHotels.isEmpty) {
      return const Center(child: Text('No top-rated hotels found.'));
    }

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredHotels.length,
        itemBuilder: (context, index) {
          final hotel = filteredHotels[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                
              },
              child: HotelCardViewHorizontal(hotel: hotel),
            ),
          );
        },
      ),
    );
  }
}
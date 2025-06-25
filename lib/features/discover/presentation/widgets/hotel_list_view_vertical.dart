import 'package:flutter/material.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'hotel_card_view_horizontal.dart';

class HotelListViewVertical extends StatelessWidget {
  final List<Hotel> hotels;
  const HotelListViewVertical({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    // Filtra por popularidad 
    final popularHotels = hotels.where((hotel) => hotel.popularity > 200).toList();
    final visibleHotels = popularHotels.take(3).toList();

    if (visibleHotels.isEmpty) {
      return const Center(child: Text('No popular hotels found.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibleHotels.length,
      itemBuilder: (context, index) {
        final hotel = visibleHotels[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          child: HotelCardViewHorizontal(hotel: hotel),
        );
      },
    );
  }
}
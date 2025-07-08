import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<FavoriteBloc>().add(CheckIsFavoriteEvent(id: hotel.id));
    
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
                  child: BlocBuilder<FavoriteBloc, FavoriteState>(
                    buildWhen: (previous, current) {
                      return (current is IsFavoriteState && current.id == hotel.id) ||
                             (current is LoadedFavoriteState);
                    },
                    builder: (context, state) {
                      bool isFavorite = false;
                      
                      if (state is IsFavoriteState && state.id == hotel.id) {
                        isFavorite = state.isFavorite;
                      } else if (state is LoadedFavoriteState) {
                        isFavorite = state.favorites.any((h) => h.id == hotel.id);
                      }
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border, 
                            color: isFavorite ? ColorPalette.primaryColor : Colors.grey,
                          ),
                          onPressed: () {
                            if (isFavorite) {
                              context.read<FavoriteBloc>().add(
                                RemoveFavoriteEvent(id: hotel.id)
                              );
                            } else {
                              final favoriteHotel = FavoriteHotel(
                                id: hotel.id,
                                name: hotel.name,
                                imageUrl: hotel.imageUrl,
                                rating: hotel.rating,
                                pricePerNight: hotel.pricePerNight,
                                country: hotel.country,
                                city: hotel.city,
                              );
                              context.read<FavoriteBloc>().add(
                                AddFavoriteEvent(favoriteHotel: favoriteHotel)
                              );
                            }
                          },
                        ),
                      );
                    },
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
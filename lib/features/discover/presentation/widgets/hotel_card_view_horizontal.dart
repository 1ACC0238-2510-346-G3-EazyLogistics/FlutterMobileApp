import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelCardViewHorizontal extends StatelessWidget {
  final Hotel hotel;
  const HotelCardViewHorizontal({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    // Verificar favorito al construir el widget
    context.read<FavoriteBloc>().add(CheckIsFavoriteEvent(id: hotel.id));
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Hotel image with favorite icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    hotel.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<FavoriteBloc, FavoriteState>(
                    buildWhen: (previous, current) {
                      // Solo reconstruir cuando cambia el estado de favorito para este hotel
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
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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
            const SizedBox(width: 16),
            // Hotel info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stars and reviews
                  Row(
                    children: [
                      ...List.generate(
                        hotel.rating.floor(),
                        (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
                      ),
                      if (hotel.rating - hotel.rating.floor() >= 0.5)
                        const Icon(Icons.star_half, color: Colors.amber, size: 18),
                      ...List.generate(
                        5 - hotel.rating.ceil(),
                        (index) => const Icon(Icons.star_border, color: Colors.amber, size: 18),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hotel.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        " (${hotel.reviews.length} Reviews)",
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hotel.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${hotel.city}, ${hotel.country}",
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\$${hotel.pricePerNight}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: "/night",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
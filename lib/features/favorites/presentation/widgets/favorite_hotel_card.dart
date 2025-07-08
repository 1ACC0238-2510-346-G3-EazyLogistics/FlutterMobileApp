import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/discover/data/repositories/hotel_repository.dart';
import 'package:LogisticsMasters/features/discover/presentation/pages/hotel_detail_page.dart';
import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteHotelCard extends StatelessWidget {
  const FavoriteHotelCard({super.key, required this.hotel});
  final FavoriteHotel hotel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Imagen con borde redondeado
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                hotel.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Información del hotel
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
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
                  const SizedBox(height: 8),
                  Text(
                    "\$${hotel.pricePerNight}/night",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Botón de reserva
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () async {
                // Mostrar indicador de carga
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                
                // Obtener detalles completos del hotel
                final hotelRepository = HotelRepository();
                final completeHotel = await hotelRepository.getHotelById(hotel.id);
                
                // Cerrar indicador de carga
                if (context.mounted) Navigator.pop(context);
                
                if (completeHotel != null && context.mounted) {
                  // Navegar con el hotel completo Y actualizar al volver
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetailPage(hotel: completeHotel),
                    ),
                  ).then((_) {
                    // Actualizar la lista de favoritos después de volver
                    if (context.mounted) {
                      context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
                    }
                  });
                } else if (context.mounted) {
                  // Mostrar un mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not load hotel details. Using limited information.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  
                  // Navegar con la información limitada que tenemos Y actualizar al volver
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetailPage(hotel: hotel.toHotel()),
                    ),
                  ).then((_) {
                    // Actualizar la lista de favoritos después de volver
                    if (context.mounted) {
                      context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
                    }
                  });
                }
              },
              child: const Text('Book', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/discover/data/repositories/hotel_repository.dart';
import 'package:LogisticsMasters/features/discover/presentation/pages/hotel_detail_page.dart';
import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteHotelCard extends StatefulWidget {
  const FavoriteHotelCard({super.key, required this.hotel});
  final FavoriteHotel hotel;

  @override
  State<FavoriteHotelCard> createState() => _FavoriteHotelCardState();
}

class _FavoriteHotelCardState extends State<FavoriteHotelCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostrar una versión simplificada de la tarjeta con un indicador de carga
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading ${widget.hotel.name} details...'),
            ],
          ),
        ),
      );
    }

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
                widget.hotel.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // Información del hotel
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hotel.name,
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
                          "${widget.hotel.city}, ${widget.hotel.country}",
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${widget.hotel.pricePerNight}/night",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Botón de reserva
            Tooltip(
              message: 'Book this hotel',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _navigateToHotelDetail,
                child: const Text('Book', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToHotelDetail() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Obtener detalles completos del hotel
      final hotelRepository = HotelRepository();
      final completeHotel = await hotelRepository.getHotelById(widget.hotel.id);
      
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      if (completeHotel != null) {
        // Navegar con el hotelId en lugar del objeto hotel completo
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailPage(hotelId: completeHotel.id),
          ),
        );
        
        // Actualizar la lista de favoritos después de volver
        if (mounted) {
          context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
        }
      } else {
        // Mostrar un mensaje de error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not load hotel details.'),
              duration: Duration(seconds: 2),
            ),
          );
          
          // Navegar usando el ID del hotel de favoritos
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDetailPage(hotelId: widget.hotel.id),
            ),
          );
          
          // Actualizar la lista de favoritos después de volver
          if (mounted) {
            context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
          }
        }
      }
    } catch (e) {
      // Manejar error
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading hotel details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
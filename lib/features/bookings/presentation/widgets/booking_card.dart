import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/auth/data/datasources/auth_service.dart';
import 'package:LogisticsMasters/features/bookings/data/book_item_service.dart';
import 'package:LogisticsMasters/features/bookings/domain/book_item.dart';
import 'package:LogisticsMasters/features/bookings/presentation/pages/booking_detail.dart';
import 'package:LogisticsMasters/features/discover/presentation/pages/hotel_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatefulWidget {
  final BookItem booking;
  final bool isUpcoming;
  final VoidCallback onRefresh;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isUpcoming,
    required this.onRefresh,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _isCancelling = false;
  late BookItem booking;

  @override
  void initState() {
    super.initState();
    booking = widget.booking;
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy, hh:mm a');

    if (_isCancelling) {
      // Mostrar un indicador de carga dentro del card en lugar de un diálogo
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Cancelling booking..."),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking ID con etiqueta de cancelado si aplica
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking ID: ${booking.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (booking.status == 'cancelled')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      'Cancelled',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Booking date
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Booking Date: ${dateFormat.format(booking.checkInDate)} - ${dateFormat.format(booking.checkOutDate)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),

          // Hotel info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                // Hotel image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    booking.hotelImage,
                    width: 80,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 60,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Hotel details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel name with rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              booking.hotelName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          const Text(
                            '4.0', // Idealmente, obtener la calificación real del hotel
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(115 Reviews)', // Idealmente, obtener el número real de reseñas
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              booking.location,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.isUpcoming && booking.status != 'cancelled')
                  // Cancel button for upcoming bookings
                  OutlinedButton(
                    onPressed: () => _showCancelDialog(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                else if (!widget.isUpcoming && booking.status != 'cancelled')
                  // Write a Review button for past bookings
                  OutlinedButton(
                    onPressed: () {
                      // Navegar a la página de escribir reseña
                      // Implementar en el futuro
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Write a Review',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                else
                  // Si está cancelada, mostrar un botón deshabilitado
                  OutlinedButton(
                    onPressed: null, // Deshabilitado
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancelled',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),

                // View Details o Book Again
                ElevatedButton(
                  onPressed: () {
                    if (booking.status != 'cancelled') {
                      // Si no está cancelada, mostrar detalles de la reserva
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookingDetailPage(booking: booking),
                        ),
                      ).then((result) {
                        // Si recibimos true como resultado, refrescar la lista
                        if (result == true) {
                          widget.onRefresh();
                        }
                      });
                    } else {
                      // Si está cancelada, redirigir a la página de detalles del hotel para reservar nuevamente
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelDetailPage(
                            hotelId: booking.hotelId,
                            // Puedes pasar parámetros adicionales si es necesario
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: booking.status == 'cancelled'
                        ? ColorPalette.primaryColor
                        : ColorPalette.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    booking.status == 'cancelled'
                        ? 'Book Again'
                        : 'View Details',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCancelDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text('Are you sure you want to cancel this booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelBooking();
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelBooking() async {
    // Activar el indicador de carga
    setState(() {
      _isCancelling = true;
    });

    try {
      final service = BookItemService();
      final authService = AuthService();
      final currentUser = await authService.getCurrentUser();

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await service.cancelBooking(currentUser.id, booking.id!);

      // Esperar un momento para asegurar que la operación se haya completado
      await Future.delayed(const Duration(milliseconds: 500));

      // Actualizar el estado local de la reserva
      setState(() {
        booking.status = 'cancelled';
        _isCancelling = false;
      });

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refrescar la lista completa
      widget.onRefresh();
    } catch (e) {
      print("Error cancelling booking: $e");

      // Desactivar el indicador de carga
      setState(() {
        _isCancelling = false;
      });

      // Mostrar mensaje de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

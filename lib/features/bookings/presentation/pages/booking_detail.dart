import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/auth/data/datasources/auth_service.dart';
import 'package:LogisticsMasters/features/bookings/data/book_item_service.dart';
import 'package:LogisticsMasters/features/bookings/domain/book_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends StatefulWidget {
  final BookItem booking;

  const BookingDetailPage({super.key, required this.booking});

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  bool _isCancelling = false;
  late BookItem booking;

  @override
  void initState() {
    super.initState();
    booking = widget.booking;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details'), elevation: 0),
      body: _isCancelling
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cancelling your booking...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel image and info card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            booking.hotelImage,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 200,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),

                        // Hotel info
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Hotel name
                                  Expanded(
                                    child: Text(
                                      booking.hotelName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // Price per night
                                  Text(
                                    '${currencyFormat.format(booking.pricePerNight)}/night',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.primaryColor,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Location
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      booking.location,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
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

                  const SizedBox(height: 24),

                  // Booking details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Booking ID
                        _buildDetailRow('Booking ID', '#${booking.id}'),
                        const Divider(height: 24),

                        // Check-in
                        _buildDetailRow(
                          'Check-in',
                          dateFormat.format(booking.checkInDate),
                        ),
                        const SizedBox(height: 12),

                        // Check-out
                        _buildDetailRow(
                          'Check-out',
                          dateFormat.format(booking.checkOutDate),
                        ),
                        const SizedBox(height: 12),

                        // Nights
                        _buildDetailRow('Nights', '${booking.nights}'),
                        const SizedBox(height: 12),

                        // Guests
                        _buildDetailRow(
                          'Guests',
                          '${booking.adults} Adult${booking.adults > 1 ? 's' : ''}'
                              '${booking.children > 0 ? ', ${booking.children} Child${booking.children > 1 ? 'ren' : ''}' : ''}'
                              '${booking.infants > 0 ? ', ${booking.infants} Infant${booking.infants > 1 ? 's' : ''}' : ''}',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Price details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Room price
                        _buildPriceRow(
                          '${currencyFormat.format(booking.pricePerNight)} × ${booking.nights} night${booking.nights > 1 ? 's' : ''}',
                          currencyFormat.format(
                            booking.pricePerNight * booking.nights,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Taxes
                        _buildPriceRow(
                          'Taxes & Fees',
                          currencyFormat.format(booking.taxes),
                        ),

                        const Divider(height: 24),

                        // Total price
                        _buildPriceRow(
                          'Total Amount',
                          currencyFormat.format(booking.totalPrice),
                          isTotal: true,
                        ),

                        const SizedBox(height: 8),

                        // Payment method
                        Row(
                          children: [
                            Text(
                              'Paid with ${_formatPaymentMethod(booking.paymentMethod)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _getPaymentIcon(booking.paymentMethod),
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Cancel button
                  if (_isUpcoming() && booking.status != 'cancelled')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showCancelDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Cancel Booking',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? ColorPalette.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method) {
      case 'creditCard':
        return 'Credit Card';
      case 'paypal':
        return 'PayPal';
      case 'googlePay':
        return 'Google Pay';
      case 'applePay':
        return 'Apple Pay';
      default:
        return method;
    }
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'creditCard':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'googlePay':
        return Icons.g_mobiledata;
      case 'applePay':
        return Icons.apple;
      default:
        return Icons.payment;
    }
  }

  bool _isUpcoming() {
    final now = DateTime.now();
    return booking.checkOutDate.isAfter(now) ||
        DateUtils.isSameDay(booking.checkOutDate, now);
  }

  Future<void> _showCancelDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.',
          ),
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
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelBooking() async {
    // Activar indicador de carga
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

      // Actualizar la copia local
      setState(() {
        booking.status = 'cancelled';
        _isCancelling = false;
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking cancelled successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Esperar un momento y regresar
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context, true); // Return true to refresh the list
      }
    } catch (e) {
      // Desactivar indicador de carga
      setState(() {
        _isCancelling = false;
      });

      // Mostrar mensaje de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling booking: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

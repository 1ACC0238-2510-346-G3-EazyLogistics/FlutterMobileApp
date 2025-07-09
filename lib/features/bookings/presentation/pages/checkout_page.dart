import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/auth/data/datasources/auth_service.dart';
import 'package:LogisticsMasters/features/bookings/domain/book_item.dart';
import 'package:LogisticsMasters/features/bookings/data/book_item_service.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:LogisticsMasters/features/bookings/presentation/pages/payment_success_page.dart';
import 'package:LogisticsMasters/features/bookings/presentation/pages/add_card_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int nights;
  final int adults;
  final int children;
  final int infants;
  final double subtotal;
  final double taxes;
  final double total;
  
  const CheckoutPage({
    super.key,
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.adults,
    required this.children,
    required this.infants,
    required this.subtotal,
    required this.taxes,
    required this.total,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final BookItemService _bookingService = BookItemService();
  final AuthService _authService = AuthService();
  String _paymentMethod = 'creditCard';
  bool _isProcessing = false;
  String _errorMessage = '';
  
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '\$');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm & Pay'),
        elevation: 0,
      ),
      body: _isProcessing
          ? _buildLoadingView()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.hotel.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ...List.generate(
                                    widget.hotel.rating.floor(),
                                    (index) => const Icon(Icons.star, size: 16, color: Colors.amber),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${widget.hotel.rating} (${widget.hotel.reviews.length} Reviews)",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
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
                                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "${widget.hotel.city}, ${widget.hotel.country}",
                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${widget.adults} adults | ${widget.children} ${widget.children == 1 ? 'child' : 'children'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Booking details section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Booking Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Dates
                        _buildDetailItem(
                          title: 'Dates',
                          value: "${_dateFormat.format(widget.checkInDate)} - ${_dateFormat.format(widget.checkOutDate)}",
                          icon: Icons.edit,
                          onTap: () {
                            // Volver a la selección de fechas
                            Navigator.pop(context);
                          },
                        ),
                        
                        const Divider(),
                        
                        // Guests
                        _buildDetailItem(
                          title: 'Guests',
                          value: "${widget.adults} adults, ${widget.children} ${widget.children == 1 ? 'child' : 'children'}, ${widget.infants} ${widget.infants == 1 ? 'infant' : 'infants'}",
                          icon: Icons.edit,
                          onTap: () {
                            // Volver a la selección de huéspedes
                            Navigator.pop(context);
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Payment section
                        const Text(
                          'Choose how to pay',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Payment options
                        _buildPaymentOption(
                          title: 'Pay in full',
                          description: 'Pay the total now and you\'re all set.',
                          value: 'creditCard',
                        ),
                        
                        const SizedBox(height: 12),
                        
                        _buildPaymentOption(
                          title: 'Pay part now, part later',
                          description: 'Pay part now and you\'re all set.',
                          value: 'paypal',
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Payment method section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pay with',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Navegar a la página de añadir tarjeta
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddCardPage()),
                                );
                                
                                // Si se añadió una tarjeta correctamente (se devolvió un resultado)
                                if (result != null && result is Map<String, dynamic>) {
                                  setState(() {
                                    // Actualizar el método de pago según el tipo de tarjeta
                                    _paymentMethod = 'creditCard'; // O usar result['cardType']
                                    
                                    // Mostrar confirmación al usuario
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Card ending in ${result['cardNumber'].toString().substring(result['cardNumber'].toString().length - 4)} added successfully'),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  });
                                }
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(color: ColorPalette.primaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Payment methods
                        Row(
                          children: [
                            _buildPaymentMethodCard(
                              image: 'assets/images/visa.png',
                              isSelected: _paymentMethod == 'creditCard',
                            ),
                            const SizedBox(width: 8),
                            _buildPaymentMethodCard(
                              image: 'assets/images/mastercard.png',
                              isSelected: false,
                            ),
                            const SizedBox(width: 8),
                            _buildPaymentMethodCard(
                              image: 'assets/images/paypal.png',
                              isSelected: _paymentMethod == 'paypal',
                            ),
                            const SizedBox(width: 8),
                            _buildPaymentMethodCard(
                              image: 'assets/images/gpay.png',
                              isSelected: false,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Price details
                        const Text(
                          'Price Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Price breakdown
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_currencyFormat.format(widget.hotel.pricePerNight)} x ${widget.nights} nights',
                            ),
                            Text(
                              _currencyFormat.format(widget.subtotal),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Discount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount'),
                            Text(
                              _currencyFormat.format(0),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Taxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Occupancy taxes and fees'),
                            Text(
                              _currencyFormat.format(widget.taxes),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        const Divider(),
                        const SizedBox(height: 8),
                        
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Grand Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _currencyFormat.format(widget.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _isProcessing
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _processBooking,
                child: const Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton(
          icon: Icon(icon, color: ColorPalette.primaryColor),
          onPressed: onTap,
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String description,
    required String value,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _paymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _paymentMethod == value
                ? ColorPalette.primaryColor
                : Colors.grey.withOpacity(0.3),
            width: _paymentMethod == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _paymentMethod,
              activeColor: ColorPalette.primaryColor,
              onChanged: (newValue) {
                setState(() {
                  _paymentMethod = newValue!;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String image,
    required bool isSelected,
  }) {
    return Container(
      width: 64,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? ColorPalette.primaryColor
              : Colors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(image, fit: BoxFit.contain),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Processing your booking...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _processBooking() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Crear un BookItem
      final bookItem = BookItem(
        hotelId: widget.hotel.id,
        hotelName: widget.hotel.name,
        hotelImage: widget.hotel.imageUrl,
        location: "${widget.hotel.city}, ${widget.hotel.country}",
        checkInDate: widget.checkInDate,
        checkOutDate: widget.checkOutDate,
        adults: widget.adults,
        children: widget.children,
        infants: widget.infants,
        pricePerNight: widget.hotel.pricePerNight.toDouble(),
        nights: widget.nights,
        taxes: widget.taxes,
        totalPrice: widget.total,
        paymentMethod: _paymentMethod,
        isPaid: true,
        bookingDate: DateTime.now(),
      );

      // Obtener el ID del usuario actual
      final currentUser = await _authService.getCurrentUser();
      
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Enviar la reserva al servidor - asegurar que el ID se envía como String
      final createdBooking = await _bookingService.createBooking(
        bookItem,
        currentUser.id.toString(), // Convertir el ID a String de forma explícita
      );

      // Simulamos un tiempo de procesamiento
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            booking: createdBooking,
          ),
        ),
        (route) => route.isFirst, 
      );
      
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = e.toString();
      });
      
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
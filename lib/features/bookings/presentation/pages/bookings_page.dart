import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/auth/data/datasources/auth_service.dart';
import 'package:LogisticsMasters/features/bookings/data/book_item_service.dart';
import 'package:LogisticsMasters/features/bookings/domain/book_item.dart';
import 'package:LogisticsMasters/features/bookings/presentation/pages/booking_detail.dart';
import 'package:LogisticsMasters/features/bookings/presentation/widgets/booking_card.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookItemService _bookingService = BookItemService();
  final AuthService _authService = AuthService();
  List<BookItem> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Obtener el usuario actual
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Cargar las reservas del usuario
      final bookings = await _bookingService.getUserBookings(
        currentUser.id.toString(),
      );

      if (!mounted) return;

      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Failed to load bookings: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // Filtrar reservas próximas (fecha checkout >= hoy y no canceladas)
  List<BookItem> get _upcomingBookings {
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              (booking.checkOutDate.isAfter(now) ||
                  DateUtils.isSameDay(booking.checkOutDate, now)) &&
              booking.status != 'cancelled',
        )
        .toList();
  }

  // Filtrar reservas pasadas (fecha checkout < hoy o canceladas)
  List<BookItem> get _pastBookings {
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              (booking.checkOutDate.isBefore(now) &&
                  !DateUtils.isSameDay(booking.checkOutDate, now)) ||
              booking.status == 'cancelled',
        )
        .toList();
  }

  // Método para manejar eliminación y actualización de la UI
  Future<void> _deleteBooking(BookItem booking) async {
    try {
      // Obtener el usuario actual
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Eliminar la reserva de la lista local primero para feedback inmediato
      setState(() {
        _bookings.removeWhere((item) => item.id == booking.id);
      });

      // Intentar eliminar en el servidor
      try {
        await _bookingService.deleteBooking(
          currentUser.id,
          booking.id ?? 'unknown-booking',
          currentUser.id.toString(),
        );
      } catch (e) {
        // Si falla la eliminación en el servidor, volver a añadir a la lista local
        setState(() {
          _bookings.add(booking);
        });
        throw e; // Relanzar para mostrar mensaje de error
      }

      // Mostrar mensaje con opción para deshacer
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${booking.hotelName} booking removed"),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () async {
                // Restaurar localmente
                setState(() {
                  _bookings.add(booking);
                });

                try {
                  // Restaurar en el servidor
                  await _bookingService.undoDeleteBooking(
                    currentUser.id,
                    booking.id ?? 'unknown-booking',
                    currentUser.id.toString(),
                  );
                } catch (e) {
                  // Si falla, volver a cargar todas las reservas
                  print("Error restoring booking: $e");
                  _loadBookings();
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Mostrar mensaje de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove booking: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: ColorPalette.primaryColor,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : RefreshIndicator(
              onRefresh: _loadBookings,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Upcoming bookings tab
                  _buildBookingsList(_upcomingBookings, isUpcoming: true),

                  // Past bookings tab
                  _buildBookingsList(_pastBookings, isUpcoming: false),
                ],
              ),
            ),
    );
  }

  Widget _buildBookingsList(
    List<BookItem> bookings, {
    required bool isUpcoming,
  }) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.event_available : Icons.history,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming bookings' : 'No past bookings',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming
                  ? 'Explore hotels to make a new booking'
                  : 'Your booking history will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        // Si es una reserva pasada, permitir deslizar para eliminar
        if (!isUpcoming) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Dismissible(
              key: Key(booking.id ?? 'booking-${index}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(height: 4),
                    Text('Remove', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                // Confirmar la eliminación mediante un diálogo
                return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Remove Booking'),
                      content: const Text(
                        'Are you sure you want to remove this booking from your history?',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                // Eliminar la reserva
                _deleteBooking(booking);
              },
              child: GestureDetector(
                onTap: () {
                  // Navigate to booking detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailPage(booking: booking),
                    ),
                  ).then((result) {
                    // Si recibimos true, significa que necesitamos refrescar
                    if (result == true) {
                      _loadBookings();
                    }
                  });
                },
                child: BookingCard(
                  booking: booking,
                  isUpcoming: isUpcoming,
                  onRefresh: _loadBookings,
                ),
              ),
            ),
          );
        } else {
          // Para reservas próximas, mantener la implementación original
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                // Navigate to booking detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailPage(booking: booking),
                  ),
                ).then((result) {
                  // Si recibimos true, significa que necesitamos refrescar
                  if (result == true) {
                    _loadBookings();
                  }
                });
              },
              child: BookingCard(
                booking: booking,
                isUpcoming: isUpcoming,
                onRefresh: _loadBookings,
              ),
            ),
          );
        }
      },
    );
  }
}

import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/bookings/presentation/pages/date_selection_page.dart';
import 'package:LogisticsMasters/features/discover/data/repositories/hotel_repository.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:LogisticsMasters/features/discover/presentation/widgets/reviews_list.dart';
import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelDetailPage extends StatefulWidget {
  final String hotelId;
  
  const HotelDetailPage({
    super.key,
    required this.hotelId,
  });
  
  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  bool _isFavorite = false;
  bool _isLoading = true;
  Hotel? _hotel;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    // Cargar los datos del hotel
    _loadHotelData();
    // Verificar si el hotel ya es favorito cuando la página se inicializa
    context.read<FavoriteBloc>().add(CheckIsFavoriteEvent(id: widget.hotelId));
  }
  
  Future<void> _loadHotelData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final repository = HotelRepository();
      final hotel = await repository.getHotelById(widget.hotelId);
      
      if (mounted) {
        setState(() {
          _hotel = hotel;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading hotel data: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Crear un FavoriteHotel desde el Hotel
  FavoriteHotel _createFavoriteHotel() {
    if (_hotel == null) {
      throw Exception('Cannot create favorite: Hotel data not loaded');
    }
    
    return FavoriteHotel(
      id: widget.hotelId,
      name: _hotel!.name,
      imageUrl: _hotel!.imageUrl,
      rating: _hotel!.rating,
      pricePerNight: _hotel!.pricePerNight,
      country: _hotel!.country,
      city: _hotel!.city,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteBloc, FavoriteState>(
      listener: (context, state) {
        if (state is IsFavoriteState && state.id == widget.hotelId) {
          setState(() {
            _isFavorite = state.isFavorite;
          });
        } else if (state is LoadedFavoriteState) {
          // Actualizar estado después de añadir/eliminar favorito
          final exists = state.favorites.any((h) => h.id == widget.hotelId);
          if (_isFavorite != exists) {
            setState(() {
              _isFavorite = exists;
            });
          }
        }
      },
      child: Scaffold(
        appBar: _isLoading ? AppBar(title: const Text('Loading...')) : null,
        body: _isLoading 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading hotel details...'),
                ],
              ),
            )
          : _errorMessage != null 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(_errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadHotelData,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              )
            : _hotel == null
              ? const Center(child: Text('Hotel not found'))
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 260,
                      pinned: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: ColorPalette.primaryColor),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _hotel!.imageUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 40,
                              right: 20,
                              child: CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.9),
                                child: IconButton(
                                  icon: Icon(
                                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: _isFavorite ? ColorPalette.primaryColor : ColorPalette.primaryColor,
                                  ),
                                  onPressed: () {
                                    if (_isFavorite) {
                                      // Si ya es favorito, eliminar de favoritos
                                      context.read<FavoriteBloc>().add(
                                        RemoveFavoriteEvent(id: widget.hotelId),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("${_hotel!.name} removed from favorites"),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      // Si no es favorito, añadir a favoritos
                                      context.read<FavoriteBloc>().add(
                                        AddFavoriteEvent(favoriteHotel: _createFavoriteHotel()),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("${_hotel!.name} added to favorites"),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Resto del código, reemplazando widget.hotel con _hotel!
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stars and reviews
                            Row(
                              children: [
                                ...List.generate(
                                  _hotel!.rating.floor(),
                                  (index) => const Icon(Icons.star, color: Colors.amber, size: 22),
                                ),
                                if (_hotel!.rating - _hotel!.rating.floor() >= 0.5)
                                  const Icon(Icons.star_half, color: Colors.amber, size: 22),
                                ...List.generate(
                                  5 - _hotel!.rating.ceil(),
                                  (index) => const Icon(Icons.star_border, color: Colors.amber, size: 22),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _hotel!.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " (${_hotel!.reviews.length} Reviews)",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _hotel!.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  "${_hotel!.city}, ${_hotel!.country}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Overview",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _hotel!.description,
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                    // Reviews section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ReviewsList(reviews: _hotel!.reviews),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        bottomNavigationBar: _isLoading || _errorMessage != null || _hotel == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\$${_hotel!.pricePerNight}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: "/night",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DateSelectionPage(hotel: _hotel!),
                        ),
                      );
                    },
                    child: const Text(
                      "Select Date",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
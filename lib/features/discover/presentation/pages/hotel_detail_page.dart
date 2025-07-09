import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:LogisticsMasters/features/discover/presentation/widgets/reviews_list.dart';
import 'package:LogisticsMasters/features/favorites/domain/entities/favorite_hotel.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotel hotel;
  const HotelDetailPage({super.key, required this.hotel});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  bool _isFavorite = false;
  
  @override
  void initState() {
    super.initState();
    // Verificar si el hotel ya es favorito cuando la página se inicializa
    context.read<FavoriteBloc>().add(CheckIsFavoriteEvent(id: widget.hotel.id));
  }

  // Crear un FavoriteHotel desde el Hotel
  FavoriteHotel _createFavoriteHotel() {
    return FavoriteHotel(
      id: widget.hotel.id,
      name: widget.hotel.name,
      imageUrl: widget.hotel.imageUrl,
      rating: widget.hotel.rating,
      pricePerNight: widget.hotel.pricePerNight,
      country: widget.hotel.country,
      city: widget.hotel.city,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteBloc, FavoriteState>(
      listener: (context, state) {
        if (state is IsFavoriteState && state.id == widget.hotel.id) {
          setState(() {
            _isFavorite = state.isFavorite;
          });
        } else if (state is LoadedFavoriteState) {
          // Actualizar estado después de añadir/eliminar favorito
          final exists = state.favorites.any((h) => h.id == widget.hotel.id);
          if (_isFavorite != exists) {
            setState(() {
              _isFavorite = exists;
            });
          }
        }
      },
      child: Scaffold(
        body: CustomScrollView(
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
                      widget.hotel.imageUrl,
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
                                RemoveFavoriteEvent(id: widget.hotel.id),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${widget.hotel.name} removed from favorites"),
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
                                  content: Text("${widget.hotel.name} added to favorites"),
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
                          widget.hotel.rating.floor(),
                          (index) => const Icon(Icons.star, color: Colors.amber, size: 22),
                        ),
                        if (widget.hotel.rating - widget.hotel.rating.floor() >= 0.5)
                          const Icon(Icons.star_half, color: Colors.amber, size: 22),
                        ...List.generate(
                          5 - widget.hotel.rating.ceil(),
                          (index) => const Icon(Icons.star_border, color: Colors.amber, size: 22),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.hotel.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " (${widget.hotel.reviews.length} Reviews)",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.hotel.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.hotel.city}, ${widget.hotel.country}",
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
                      widget.hotel.description,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // En la sección de reviews de HotelDetailPage
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
                    ReviewsList(reviews: widget.hotel.reviews),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
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
                      text: "\$${widget.hotel.pricePerNight}",
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
                  // Acción para seleccionar fecha
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
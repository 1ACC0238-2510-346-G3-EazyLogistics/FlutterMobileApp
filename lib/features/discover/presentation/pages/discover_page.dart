import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_bloc.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_event.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_state.dart';
import 'package:LogisticsMasters/features/discover/presentation/widgets/hotel_card_view_vertical.dart';
import 'package:LogisticsMasters/features/discover/presentation/widgets/hotel_card_view_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/discover/presentation/widgets/banner_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:LogisticsMasters/features/discover/presentation/pages/hotel_see_all_page.dart';
import 'package:LogisticsMasters/features/discover/data/models/card_type.dart';
import 'package:LogisticsMasters/features/discover/presentation/pages/hotel_detail_page.dart';

class DiscoverPage extends StatefulWidget {
  final String userName;
  const DiscoverPage({super.key, required this.userName});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with RouteAware {
  RouteObserver<PageRoute>? _routeObserver;

  @override
  void initState() {
    super.initState();
    context.read<HotelBloc>().add(GetHotels());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver = RouteObserver<PageRoute>();
    _routeObserver?.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    // Cuando vuelves a esta página, asegúrate de que ningún elemento tenga foco
    FocusScope.of(context).unfocus();
    super.didPopNext();
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerView(userName: widget.userName),
            // Best Hotels Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Best Hotels",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<HotelBloc, HotelState>(
                    builder: (context, state) {
                      if (state is LoadedHotelState) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelSeeAllPage(
                                  hotels: state.hotels.where((h) => h.rating > 4.6).toList(),
                                  cardType: CardType.vertical,
                                  title: "Best Hotels",
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(
                              color: ColorPalette.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 290,
              child: BlocBuilder<HotelBloc, HotelState>(
                builder: (context, state) {
                  if (state is LoadingHotelState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadedHotelState) {
                    final hotels = state.hotels.where((hotel) => hotel.rating > 4.6).take(3).toList();
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        final hotel = hotels[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HotelDetailPage(hotel: hotel),
                                ),
                              );
                            },
                            child: HotelCardViewVertical(hotel: hotel),
                          ),
                        );
                      },
                    );
                  } else if (state is FailureHotelState) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            // Most Popular Hotels Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Most Popular Hotels",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<HotelBloc, HotelState>(
                    builder: (context, state) {
                      if (state is LoadedHotelState) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelSeeAllPage(
                                  hotels: state.hotels.where((h) => h.popularity > 200).toList(),
                                  cardType: CardType.horizontal,
                                  title: "Most Popular Hotels",
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(
                              color: ColorPalette.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<HotelBloc, HotelState>(
              builder: (context, state) {
                if (state is LoadedHotelState) {
                  final hotels = state.hotels.where((hotel) => hotel.popularity > 200).take(3).toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = hotels[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelDetailPage(hotel: hotel),
                              ),
                            );
                          },
                          child: HotelCardViewHorizontal(hotel: hotel),
                        ),
                      );
                    },
                  );
                } else if (state is LoadingHotelState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FailureHotelState) {
                  return Center(child: Text(state.errorMessage));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
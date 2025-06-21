import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_bloc.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_event.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_state.dart';
import 'package:LogisticsMasters/features/discover/presentation/widgets/hotel_card_view_vertical.dart';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/discover/presentation/widgets/banner_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverPage extends StatefulWidget {
  final String userName;
  const DiscoverPage({super.key, required this.userName});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    context.read<HotelBloc>().add(GetHotels());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerView(userName: widget.userName),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Best Hotels",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Acción para "See All"
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(
                        color: ColorPalette.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                    final hotels = state.hotels;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        final hotel = hotels[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: HotelCardViewVertical(hotel: hotel),
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
            // ...vertical hotel cards
          ],
        ),
      ),
    );
  }
}
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_bloc.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_event.dart';
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
      body: Column(
        children: [
          BannerView(userName: widget.userName),
          // Info de hoteles 
          Text("Best Hotels", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ColorPalette.primaryColor )),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                // Ejemplo de hotel
                Card(
                  child: ListTile(
                    title: Text("Hotel Example"),
                    subtitle: Text("Description here"),
                  ),
                ),
                // ...más hoteles
              ],
            ),
          ),
        ],
      ),
    );
  }
}
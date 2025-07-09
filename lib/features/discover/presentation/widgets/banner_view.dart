import 'dart:ui';
import 'package:LogisticsMasters/features/discover/presentation/blocs/search_bloc.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/search_event.dart';
import 'package:LogisticsMasters/features/discover/presentation/pages/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerView extends StatefulWidget {  // Cambiado a StatefulWidget
  final String userName;
  const BannerView({super.key, required this.userName});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();  // Liberar recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Cerrar teclado al tocar fuera del campo
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banner-machu-picchu.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.place, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Lima, Peru",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Hey, ${widget.userName}!\nTell us where you want to go",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(48.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          color: Colors.white.withOpacity(0.2),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  focusNode: _searchFocusNode,
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                  cursorColor: ColorPalette.primaryColor,
                                  decoration: const InputDecoration(
                                    hintText: "Search places",
                                    hintStyle: TextStyle(color: Colors.white70),
                                    // Eliminar todas las líneas
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    isCollapsed: true,
                                  ),
                                  onSubmitted: (query) {
                                    if (query.isNotEmpty) {
                                      // Importante: Cerrar teclado primero
                                      _searchFocusNode.unfocus();
                                      
                                      // Breve delay para permitir que el teclado se cierre completamente
                                      Future.delayed(const Duration(milliseconds: 100), () {
                                        // Primero actualizar el bloc de búsqueda
                                        context.read<SearchBloc>().add(SearchHotelsEvent(query: query));
                                        
                                        // Luego navegar a la página de resultados
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SearchResultsPage(query: query),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
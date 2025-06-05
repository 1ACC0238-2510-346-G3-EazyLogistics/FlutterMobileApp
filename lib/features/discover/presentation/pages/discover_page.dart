import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/core/theme/color_palette.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Banner superior
          ClipRRect(
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
                  // Oscurecer
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  // Contenido sobre la imagen
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
                        const Text(
                          "Hey, {userName}!\nTell us where you want to go",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Barra de búsqueda con desenfoque
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
                                  // Barra de búsqueda editable
                                  Expanded(
                                    child: TextField(
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                      cursorColor: ColorPalette.primaryColor,
                                      decoration: const InputDecoration(
                                        hintText: "Search places",
                                        hintStyle: TextStyle(color: Colors.white70),
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                                      ),
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
          // Info de hoteles 
          Text("Best Hotels", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
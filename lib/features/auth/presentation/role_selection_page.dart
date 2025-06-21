import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  final VoidCallback onUserSelected;
  final VoidCallback onAdminSelected;

  const RoleSelectionPage({
    super.key,
    required this.onUserSelected,
    required this.onAdminSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: Image.asset(
                    "assets/images/logo-blanco-turquesa.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  '¿Cómo deseas registrarte?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.person_outline, color: Colors.white),
                  label: const Text(
                    'Usuario',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: onUserSelected,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: ColorPalette.primaryColor,
                      width: 2,
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.business, color: ColorPalette.primaryColor),
                  label: Text(
                    'Administrador',
                    style: TextStyle(
                      color: ColorPalette.primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: onAdminSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

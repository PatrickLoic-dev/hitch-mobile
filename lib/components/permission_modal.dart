// lib/components/permission_modal.dart

import 'package:flutter/material.dart';
// L'import de flutter_svg n'est plus nécessaire
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:Hitch/components/button.dart';

class PermissionModal extends StatelessWidget {
  final String pngAsset; // MODIFICATION: Le nom de la variable a été clarifié
  final String title;
  final String description;
  final VoidCallback onAllow;
  final VoidCallback onMaybeLater;

  const PermissionModal({
    super.key,
    required this.pngAsset, // MODIFICATION: Le paramètre a été mis à jour
    required this.title,
    required this.description,
    required this.onAllow,
    required this.onMaybeLater,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // MODIFICATION: Remplacement de SvgPicture par Image.asset
            Image.asset(pngAsset, height: 150),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Jokker',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Jokker',
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Button(onPressed: onAllow, text: 'Allow'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, // Pour prendre toute la largeur disponible
              child: ElevatedButton(
                onPressed: onMaybeLater,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAEAEA), // Fond gris
                  foregroundColor: Colors.black, // Couleur du texte
                  elevation: 0, // Pas d'ombre
                  shape: const StadiumBorder(), // Bords complètement arrondis
                  padding: const EdgeInsets.symmetric(vertical: 14), // Ajustement du padding vertical
                ),
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(
                    fontFamily: 'Jokker',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

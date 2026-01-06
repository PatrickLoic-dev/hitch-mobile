// lib/components/location_permission_modal.dart

import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart'; // Votre composant bouton personnalisé
import 'package:Hitch/screens/registration/select_gender_page.dart';

class LocationPermissionModal extends StatelessWidget {
  const LocationPermissionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Appliquer les coins arrondis en haut du modal
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
          mainAxisSize: MainAxisSize.min, // Le modal prendra la hauteur de son contenu
          crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les widgets horizontalement
          children: [
            // 1. SVG
            Image.asset(
              'assets/images/map_illustration.png', // REMPLACER par le chemin de votre SVG
              height: 150, // Ajustez la hauteur selon vos besoins
            ),
            const SizedBox(height: 24),

            // 2. Titre
            const Text(
              'Share your Location',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jokker',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // 3. Description
            const Text(
              'Allow drivers and riders see your location. Find riders and drivers near you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jokker',
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // 4. Bouton "Allow"
            Button(
              onPressed: () {
                print('Permission de localisation accordée !');
                // TODO: Implémenter la logique de demande de permission (ex: avec le package `permission_handler`)
                Navigator.of(context).pop(); // Ferme le modal
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SelectGenderPage(),
                  ),
                );
              },
              text: 'Allow',
            ),
            const SizedBox(height: 12),

            // 5. Bouton "Maybe Later"
            // Ici, nous utilisons TextButton pour un look plus discret
            SizedBox(
              width: double.infinity, // Pour prendre toute la largeur disponible
              child: ElevatedButton(
                onPressed: () {
                  print('Permission de localisation reportée.');
                  Navigator.of(context).pop(); // Ferme le modal
                },
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

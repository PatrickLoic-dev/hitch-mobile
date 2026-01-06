import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/screens/registration/select_role_page.dart';


class ReviewProfilePicturePage extends StatelessWidget {
  final File imageFile; // Accepte le fichier image de la page précédente

  const ReviewProfilePicturePage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les boutons
            children: [
              // 1. Bouton de retour (aligné à gauche)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Titre
              const Text(
                'Review your picture',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Description
              const Text(
                'Please check and make sure that your face is clearly visible.',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Affichage de l'image
              Center(
                child: ClipOval(
                  child: Image.file(
                    imageFile,
                    width: 240,
                    height: 240,
                    fit: BoxFit.cover, // Assure que l'image remplit le cercle
                  ),
                ),
              ),

              const Spacer(), // Pousse les boutons vers le bas

              // 5. Boutons d'action
              Button(
                onPressed: () {
                  // TODO: Logique pour sauvegarder l'image et terminer l'inscription
                  print('Photo de profil confirmée !');

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectRolePage(),
                    ),
                  );
                },
                text: 'Confirm picture',
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Retourne à la page précédente pour choisir une autre photo
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Choose another picture',
                  style: TextStyle(
                    fontFamily: 'Jokker',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/screens/registration/add_profile_picture_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/screens/registration/review_profile_picture_page.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePicturePage extends StatefulWidget {
  const AddProfilePicturePage({super.key});

  @override
  State<AddProfilePicturePage> createState() => _AddProfilePicturePageState();
}

class _AddProfilePicturePageState extends State<AddProfilePicturePage> {
  final ImagePicker _picker = ImagePicker();

  // Fonction pour ouvrir la caméra
  Future<void> _takeSelfie() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      print('Image prise depuis la caméra : ${image.path}');
      _navigateToReviewPage(image); // Navigue vers la page de révision
    }
  }

  // Fonction pour ouvrir la galerie
  Future<void> _chooseFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      print('Image choisie depuis la galerie : ${image.path}');
      _navigateToReviewPage(image); // Navigue vers la page de révision
    }
  }

  void _navigateToReviewPage(XFile image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReviewProfilePicturePage(
          imageFile: File(image.path), // On convertit XFile en File
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Bouton de retour
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 20),

              // 2. Titre principal
              const Text(
                'Add a Profile Picture',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Description
              const Text(
                'Help drivers or riders identify you more easily, this increases trust.',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // 4. Marge de 50px
              const SizedBox(height: 50),

              // 5. Titre des directives
              const Text(
                'Please follow these guidelines for easy recognition.',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // 6. Directives
              _buildGuidelineRow(Icons.light_mode_outlined, 'Use good lighting and no filters'),
              const SizedBox(height: 16),
              _buildGuidelineRow(Icons.face_retouching_natural, 'Face the camera and smile'),
              const SizedBox(height: 16),
              _buildGuidelineRow(Icons.do_not_disturb_on_outlined, 'No sunglasses, hats or anything that covers your face'),

              const Spacer(), // Pousse les boutons vers le bas

              // 7. Boutons d'action
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: _takeSelfie,
                  text: 'Take a selfie',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _chooseFromGallery,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontFamily: 'Jokker',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper pour construire une ligne de directive
  Widget _buildGuidelineRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 28),
        const SizedBox(width: 16),
        // Expanded pour que le texte ne dépasse pas de l'écran
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Jokker',
              fontSize: 14,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

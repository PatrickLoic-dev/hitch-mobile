// lib/components/profile_completed_modal.dart

import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart'; // Importez votre composant bouton

class ProfileCompletedModal extends StatelessWidget {
  final VoidCallback onStartAdventure; // La fonction à exécuter au clic

  const ProfileCompletedModal({super.key, required this.onStartAdventure});

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
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/tick.png', height: 150),
            const SizedBox(height: 24),
            const Text(
              'Profile completed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jokker',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'You can now share and receive rides with others on Hitch.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jokker',
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            // Le nouveau bouton !
            Button(
              onPressed: onStartAdventure,
              text: 'Start my adventure',
            ),
          ],
        ),
      ),
    );
  }
}

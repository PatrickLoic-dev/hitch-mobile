// lib/screens/registration/create_password_page.dart

import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart'; // Assurez-vous que le chemin est correct
import 'package:Hitch/components/location_permission_modal.dart';


class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  // Contrôleurs pour les champs de mot de passe
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Variables d'état pour la validation du mot de passe
  bool _hasEightChars = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;

  @override
  void initState() {
    super.initState();
    // Ajoute un "listener" pour vérifier le mot de passe à chaque changement
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    String password = _passwordController.text;

    // Met à jour l'état en fonction des conditions
    setState(() {
      _hasEightChars = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
    });
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

              // 2. Titre
              const Text(
                'Create your Password',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Description
              const Text(
                'Choose a password',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Champs de saisie
              TextField(
                controller: _passwordController,
                obscureText: true, // Masque le mot de passe
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true, // Masque le mot de passe
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 5. Tags de validation
              Row(
                children: [
                  _buildValidationTag('8 characters', _hasEightChars),
                  const SizedBox(width: 8),
                  _buildValidationTag('1 Uppercase', _hasUppercase),
                  const SizedBox(width: 8),
                  _buildValidationTag('1 Number', _hasNumber),
                ],
              ),

              const Spacer(), // Pousse le bouton vers le bas

              // 6. Bouton "Create Password"
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    // TODO: Ajouter la logique de création de compte
                    print('Password: ${_passwordController.text}');

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, // Permet au modal de ne pas être couvert par le clavier
                      backgroundColor: Colors.transparent, // Rend le fond du conteneur de base transparent
                      builder: (context) {
                        return const LocationPermissionModal();
                      },
                    );
                  },
                  text: 'Create Password',
                  textStyle: const TextStyle(
                      fontFamily: 'Jokker',
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper pour construire un tag de validation
  Widget _buildValidationTag(String text, bool isValid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isValid ? Colors.green.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isValid ? Colors.green : Colors.grey,
          width: 1.0,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isValid ? Colors.green.shade900 : Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Nettoie les contrôleurs pour éviter les fuites de mémoire
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

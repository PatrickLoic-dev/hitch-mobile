import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/screens/registration/create_password_page.dart';


class EnterNamePage extends StatefulWidget {
  const EnterNamePage({super.key});

  @override
  State<EnterNamePage> createState() => _EnterNamePageState();
}

class _EnterNamePageState extends State<EnterNamePage> {
  // Contrôleurs pour gérer le texte dans les champs de saisie
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Aligner les enfants au début (en haut) de la colonne
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Bouton de retour en haut
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Ramène l'utilisateur à l'écran précédent
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 20),

              // 2. Titre
              const Text(
                'Enter Your name',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Description
              const Text(
                'Enter your first name and last name',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Champs de saisie pour le prénom et le nom

              // Champ de saisie pour le prénom
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre les deux champs

              // Champ de saisie pour le nom de famille
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),

              // Ce Spacer pousse le bouton vers le bas de la page
              const Spacer(),

              // 5. Bouton "Next" en bas de la page
              SizedBox(
                width: double.infinity, // Pour que le bouton s'étire
                child: Button(
                  onPressed: () {
                    print('First Name: ${_firstNameController.text}');
                    print('Last Name: ${_lastNameController.text}');
                    // Naviguer vers la page de création de mot de passe
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreatePasswordPage(),
                      ),
                    );
                  },
                  text: 'Next',
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

  // Libérer les contrôleurs lorsque le widget est supprimé de l'arbre des widgets
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/enums/gender.enum.dart';
import 'package:Hitch/screens/registration/add_profile_picture_page.dart';



class SelectGenderPage extends StatefulWidget {
  const SelectGenderPage({super.key});

  @override
  State<SelectGenderPage> createState() => _SelectGenderPageState();
}

class _SelectGenderPageState extends State<SelectGenderPage> {
  Gender? _selectedGender;

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
                'Select your Gender',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Description
              const Text(
                'Please select your gender',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Boutons de sélection du genre
              Row(
                children: [
                  // Bouton "Female"
                  Expanded(
                    child: GenderSelectionButton(
                      text: 'Female',
                      svgAsset: 'assets/images/female_icon.png', 
                      isSelected: _selectedGender == Gender.female,
                      onTap: () {
                        setState(() {
                          _selectedGender = Gender.female;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bouton "Male"
                  Expanded(
                    child: GenderSelectionButton(
                      text: 'Male',
                      svgAsset: 'assets/images/male_icon.png', 
                      isSelected: _selectedGender == Gender.male,
                      onTap: () {
                        setState(() {
                          _selectedGender = Gender.male;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(), // Pousse le bouton vers le bas

              // 5. Bouton "Continue"
              SizedBox(
                width: double.infinity,
                child: Button(
                  // Le bouton est désactivé tant qu'un genre n'est pas sélectionné
                  onPressed: _selectedGender != null ? () {
                    print('Genre sélectionné : ${_selectedGender.toString()}');
                    // TODO: Naviguer vers la page suivante
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddProfilePicturePage(),
                      ),
                    );
                  } : null,
                  text: 'Continue',
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
}


class GenderSelectionButton extends StatelessWidget {
  final String text;
  final String svgAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderSelectionButton({
    super.key,
    required this.text,
    required this.svgAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Color(0xFFEAEAEA),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              svgAsset,
              height: 60,
              // Permet de colorer le SVG en fonction de la sélection
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Jokker',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.deepPurple : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

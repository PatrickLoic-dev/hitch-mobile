import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
// Imports nécessaires pour les modaux
import 'package:Hitch/components/permission_modal.dart';
import 'package:Hitch/components/profile_completed_modal.dart';
// NOUVEL IMPORT : Chemin vers la page de vérification du permis
import 'package:Hitch/screens/registration/driver_verification/proof_of_identity_page.dart';

//Chemin de la page d'acceuil
import 'package:Hitch/navigation/main_shell.dart';


class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});

  @override
  State<SelectRolePage> createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {

  // --- Début de la logique des modaux (conservée pour le passager) ---

  // Fonction pour afficher le modal "Profile Completed"
  void _showProfileCompletedModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false, // Empêche de fermer le modal en cliquant à l'extérieur
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProfileCompletedModal(
        onStartAdventure: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainShell()),
                (Route<dynamic> route) => false, // Cette condition supprime toutes les routes précédentes.
          );
        },
      ),
    );
  }

  // Fonction pour afficher le modal "Notifications"
  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PermissionModal(
        pngAsset: 'assets/images/notifications.png',
        title: 'Turn on Notifications',
        description: 'Get updates on driver’s or rider’s location and more through push notifications.',
        onAllow: () {
          print("Permission Notifications: Allowed");
          Navigator.of(ctx).pop();
          _showProfileCompletedModal(context);
        },
        onMaybeLater: () {
          print("Permission Notifications: Maybe Later");
          Navigator.of(ctx).pop();
          _showProfileCompletedModal(context);
        },
      ),
    );
  }

  // Fonction pour afficher le modal "Contacts"
  void _showContactsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PermissionModal(
        pngAsset: 'assets/images/contacts.png',
        title: 'Allow access to contacts',
        description: 'See rides and drivers from people you may already know.',
        onAllow: () {
          print("Permission Contacts: Allowed");
          Navigator.of(ctx).pop();
          _showNotificationsModal(context);
        },
        onMaybeLater: () {
          print("Permission Contacts: Maybe Later");
          Navigator.of(ctx).pop();
          _showNotificationsModal(context);
        },
      ),
    );
  }

  // --- Fin de la logique des modaux ---

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
                'How will you use Hitch?',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Description
              const Text(
                'Let us know how you intend to use Hitch, these helps us personalise your experience.',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),


              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/travel.png',
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                ),
              ),

              const Spacer(), // Pousse les boutons vers le bas

              // 5. Boutons d'action
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    print('Rôle sélectionné : Passenger');
                    // Le flux pour le passager reste le même, il déclenche les modaux.
                    _showContactsModal(context);
                  },
                  text: 'Passenger',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    // MODIFICATION : Au lieu d'appeler _showContactsModal,
                    // on navigue vers la page de vérification du permis.
                    print('Rôle sélectionné : Driver. Lancement du flux de vérification.');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProofOfIdentityPage(),
                      ),
                    );
                  },
                  text: 'Driver',
                  backgroundColor: const Color(0xFFE4F9C0),
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

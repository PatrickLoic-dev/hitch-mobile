import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/components/permission_modal.dart';
import 'package:Hitch/components/profile_completed_modal.dart';
import 'package:Hitch/navigation/main_shell.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/screens/registration/driver_verification/proof_of_identity_page.dart';

class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});

  @override
  State<SelectRolePage> createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {

  void _showProfileCompletedModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false, 
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProfileCompletedModal(
        onStartAdventure: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainShell()),
                (Route<dynamic> route) => false, 
          );
        },
      ),
    );
  }

  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PermissionModal(
        pngAsset: 'assets/images/notifications.png',
        title: 'Turn on Notifications',
        description: 'Get updates on your ride status and more through push notifications.',
        onAllow: () async {
          await Permission.notification.request();
          if (context.mounted) {
            Navigator.of(ctx).pop();
            _showProfileCompletedModal(context);
          }
        },
        onMaybeLater: () {
          Navigator.of(ctx).pop();
          _showProfileCompletedModal(context);
        },
      ),
    );
  }

  void _showContactsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PermissionModal(
        pngAsset: 'assets/images/contacts.png',
        title: 'Allow access to contacts',
        description: 'See rides from people you may already know.',
        onAllow: () async {
          await Permission.contacts.request();
          if (context.mounted) {
            Navigator.of(ctx).pop();
            _showNotificationsModal(context);
          }
        },
        onMaybeLater: () {
          Navigator.of(ctx).pop();
          _showNotificationsModal(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 20),

              const Text(
                'Ready to Hitch?',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Let\'s get your profile set up so you can start sharing rides with your university community.',
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

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: authProvider.isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : Button(
                      onPressed: () async {
                        try {
                          await authProvider.register('PASSENGER');
                          if (mounted) _showContactsModal(context);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      text: 'Continue as Passenger',
                    ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () async {
                    try {
                      await authProvider.register('DRIVER');
                      if (mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProofOfIdentityPage(),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                  text: 'Continue as Driver',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/components/location_permission_modal.dart

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/screens/registration/select_gender_page.dart';

class LocationPermissionModal extends StatelessWidget {
  const LocationPermissionModal({super.key});

  Future<void> _handlePermission(BuildContext context) async {
    // Request location permission using permission_handler
    final status = await Permission.location.request();
    
    if (status.isGranted || status.isLimited) {
      print('Location permission granted!');
    } else {
      print('Location permission denied.');
    }

    // In both cases, we proceed with the registration flow
    if (context.mounted) {
      Navigator.of(context).pop(); // Close modal
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SelectGenderPage(),
        ),
      );
    }
  }

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
            Image.asset(
              'assets/images/map_illustration.png',
              height: 150,
            ),
            const SizedBox(height: 24),

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

            Button(
              onPressed: () => _handlePermission(context),
              text: 'Allow',
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectGenderPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAEAEA),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
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

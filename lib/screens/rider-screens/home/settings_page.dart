import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/screens/rider-screens/home/vehicle_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isDriver = authProvider.user?.role == 'DRIVER';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Jokker',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        children: [
          _buildSettingsRow(Icons.person_outline, 'Edit Profile', onTap: () {}),
          // Only show My Vehicle for DRIVERS
          if (isDriver)
            _buildSettingsRow(Icons.directions_car_outlined, 'My Vehicle', onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VehiclePage()));
            }),
          _buildSettingsRow(Icons.notifications_outlined, 'Notifications', onTap: () {}),
          _buildSettingsRow(Icons.lock_outline, 'Privacy', onTap: () {}),
          _buildSettingsRow(Icons.credit_card, 'Payment Methods', onTap: () {}),
          _buildSettingsRow(Icons.security, 'Security', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String text, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: 'Jokker'
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}

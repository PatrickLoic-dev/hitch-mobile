import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/providers/trip_provider.dart';
import 'package:Hitch/screens/rider-screens/home/settings_page.dart';
import 'package:Hitch/screens/rider-screens/home/help_center_page.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/config/constants.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  void _showLogoutConfirmation(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jokker',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to log out?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Jokker',
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    Navigator.of(context).pop();
                    authProvider.logout();
                  },
                  text: 'Log out',
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jokker',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final tripProvider = Provider.of<TripProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String fullName = '${user.firstName} ${user.lastName}';
    final String memberSince = DateFormat('yyyy').format(user.createdAt);
    
    // Updated to use bookings and published rides
    final int tripCount = tripProvider.bookings.length + tripProvider.publishedRides.length;

    final String profilePicUrl = "${ApiConstants.baseUrl}/accounts/${user.accountId}/profile-picture";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'Jokker',
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(profilePicUrl),
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading profile picture: $exception');
                    },
                  ),
                  if (user.isVerified)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 20),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jokker',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatColumn('4.4', 'Rating', isRating: true),
                  const SizedBox(width: 40),
                  _buildStatColumn(tripCount.toString(), 'Trips'),
                ],
              ),
              const SizedBox(height: 32),
              
              _buildSectionCard(
                title: 'Profile Details',
                children: [
                  _buildDetailRow(Icons.check_circle, 'Verified passenger'),
                  _buildDetailRow(Icons.check_circle, 'Verified phone number'),
                  _buildDetailRow(Icons.check_circle, 'Verified Identity'),
                  _buildDetailRow(Icons.check_circle, 'Member since $memberSince'),
                ],
              ),
              const SizedBox(height: 20),

              _buildSectionCard(
                title: 'Other',
                children: [
                  _buildSettingsRow(Icons.settings_outlined, 'Settings', onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
                  }),
                  _buildSettingsRow(Icons.help_outline, 'Help center', onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HelpCenterPage()));
                  }),
                  _buildSettingsRow(Icons.logout, 'Logout', color: Colors.red, onTap: () {
                    _showLogoutConfirmation(context, authProvider);
                  }),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool isRating = false}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
            ),
            if (isRating) ...[
              const SizedBox(width: 4),
              const Icon(Icons.star, color: Colors.amber, size: 18),
            ],
          ],
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Jokker'),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87, fontFamily: 'Jokker'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String text, {Color? color, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: 'Jokker',
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}

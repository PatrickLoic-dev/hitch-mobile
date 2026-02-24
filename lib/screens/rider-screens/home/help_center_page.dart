import 'package:flutter/material.dart';
import 'package:Hitch/screens/rider-screens/home/terms_and_conditions_page.dart';
import 'package:Hitch/screens/rider-screens/home/privacy_policy_page.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Help Center',
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
          const Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jokker',
            ),
          ),
          const SizedBox(height: 20),
          _buildHelpRow(Icons.help_outline, 'FAQs', onTap: () {}),
          _buildHelpRow(Icons.chat_bubble_outline, 'Contact Support', onTap: () {}),
          _buildHelpRow(Icons.report_problem_outlined, 'Report an Issue', onTap: () {}),
          _buildHelpRow(Icons.description_outlined, 'Terms and Conditions', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()));
          }),
          _buildHelpRow(Icons.privacy_tip_outlined, 'Privacy Policy', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildHelpRow(IconData icon, String text, {VoidCallback? onTap}) {
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
          fontFamily: 'Jokker',
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}

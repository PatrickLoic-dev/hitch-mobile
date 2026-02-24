import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Jokker',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hitch – Protecting Your Privacy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jokker',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Effective Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Jokker',
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Introduction'),
            _buildSectionText(
                'At Hitch, your privacy is a priority. We are committed to protecting the personal data of our university community. This Privacy Policy outlines our practices regarding the collection, use, disclosure, and protection of your information when you use our mobile application and services.'),
            _buildSectionTitle('2. Information We Collect'),
            _buildSectionText(
                '2.1 Personal Data: We collect information that you provide directly to us, including your full name, university email address, phone number, profile picture, and university affiliation.\n\n'
                '2.2 Driver Information: For users acting as Drivers, we collect driver\'s license details, vehicle registration information, and insurance documentation to ensure safety and compliance.\n\n'
                '2.3 Usage & Technical Data: We automatically collect data on how you interact with our Platform, including IP addresses, device types, operating systems, and location data (specifically for facilitating ride searches and tracking).'),
            _buildSectionTitle('3. How We Use Your Information'),
            _buildSectionText(
                'We use the collected data for various professional purposes:\n'
                '• To facilitate and manage your account and profile.\n'
                '• To process ride bookings and coordinate transportation.\n'
                '• To securely process payments and manage your Wallet transactions.\n'
                '• To verify user identity and maintain a safe community environment.\n'
                '• To send important notifications, updates, and promotional content.\n'
                '• To improve our Platform\'s functionality and user experience.'),
            _buildSectionTitle('4. Data Sharing and Disclosure'),
            _buildSectionText(
                'Hitch does not sell your personal data to third parties. We share information only in the following circumstances:\n'
                '• Between Drivers and Passengers to coordinate specific rides.\n'
                '• With trusted service providers who assist in our operations (e.g., payment processors).\n'
                '• When required by law or to protect the safety and rights of our users.'),
            _buildSectionTitle('5. Data Security'),
            _buildSectionText(
                'We implement robust security measures, including end-to-end encryption and secure server protocols, to protect your data from unauthorized access, alteration, or disclosure. While we strive for absolute security, please note that no method of electronic transmission is completely infallible.'),
            _buildSectionTitle('6. Your Rights and Choices'),
            _buildSectionText(
                'You have the right to access, correct, or delete your personal information at any time through your account settings. You may also object to certain data processing activities. For detailed requests, please contact our privacy team at support@hitch.edu.'),
            _buildSectionTitle('7. Data Retention'),
            _buildSectionText(
                'We retain your personal information for as long as your account is active or as needed to provide you with services. We also retain and use information as necessary to comply with legal obligations and resolve disputes.'),
            _buildSectionTitle('8. Changes to This Privacy Policy'),
            _buildSectionText(
                'Hitch may update this Privacy Policy periodically. We will notify you of any significant changes by posting the new policy on the Platform and updating the effective date.'),
            _buildSectionTitle('9. Contact Us'),
            _buildSectionText(
                'If you have any questions or concerns regarding this Privacy Policy or our data practices, please reach out to us at privacy@hitch.edu.'),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Jokker',
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Colors.black87,
        fontFamily: 'Jokker',
      ),
    );
  }
}

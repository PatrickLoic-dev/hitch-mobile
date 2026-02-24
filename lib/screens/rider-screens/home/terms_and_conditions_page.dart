import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
          'Terms & Conditions',
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
              'Hitch – University Carpooling Platform',
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
                'Welcome to Hitch, a specialized carpooling platform designed exclusively for the university community. By accessing or using our mobile application and services, you signify that you have read, understood, and agree to be bound by these Terms and Conditions. These terms constitute a legally binding agreement between you and Hitch regarding your use of the platform. If you do not agree to these terms, you are prohibited from using the platform.'),
            _buildSectionTitle('2. Definitions'),
            _buildSectionText(
                '• Platform: Refers to the Hitch mobile application, website, and associated services.\n'
                '• Account: The personalized profile created by a user to access the Platform.\n'
                '• Driver: A verified user who offers a ride and shares their vehicle with others.\n'
                '• Passenger: A user who searches for and books a seat in a ride offered by a Driver.\n'
                '• Ride: A specific carpooling journey created and scheduled by a Driver on the Platform.\n'
                '• Booking: A confirmed reservation made by a Passenger for a specific Ride.\n'
                '• Wallet: The internal digital balance system used for seamless transactions within Hitch.'),
            _buildSectionTitle('3. Eligibility'),
            _buildSectionText(
                'To be eligible to use Hitch, you must be at least 18 years of age and hold a valid affiliation with a recognized university (student, faculty, or staff). You must provide accurate, current, and complete information during the registration process. Drivers must possess a valid driver\'s license and a vehicle that meets local safety standards. Hitch reserves the right to verify your status and suspend any account found providing fraudulent information.'),
            _buildSectionTitle('4. Account Registration & Security'),
            _buildSectionText(
                'Users are responsible for maintaining the confidentiality of their account credentials. You agree to notify Hitch immediately of any unauthorized use of your account. You are solely responsible for all activities that occur under your account, whether or not you have authorized such activities.'),
            _buildSectionTitle('5. Ride Creation and Booking'),
            _buildSectionText(
                '5.1 Drivers: Drivers agree to provide precise ride details, including departure point, destination, time, and available seats. Drivers must ensure their vehicle is insured and in good working condition, and they must adhere strictly to all traffic laws and safety regulations.\n\n'
                '5.2 Passengers: Passengers agree to provide accurate booking information and to arrive at the designated pickup point on time. Passengers must treat Drivers and their property with respect and pay the pre-agreed ride price through the Hitch payment system.'),
            _buildSectionTitle('6. Payments & Wallet System'),
            _buildSectionText(
                'All financial transactions are processed via the integrated Hitch Wallet. Passengers must maintain a sufficient balance to confirm a booking. Funds are transferred to the Driver\'s wallet upon successful completion of the ride. Hitch may apply a service fee to facilitate the platform\'s operations. Refunds are governed by our specific cancellation policies.'),
            _buildSectionTitle('7. Cancellations'),
            _buildSectionText(
                'We understand that plans change. Passengers and Drivers may cancel rides; however, specific rules apply. Repeated or unjustified cancellations disrupt the community and may lead to penalties, including temporary or permanent account suspension.'),
            _buildSectionTitle('8. Ratings and Reviews'),
            _buildSectionText(
                'Trust is the foundation of Hitch. Users are encouraged to leave honest feedback after each journey. You agree not to post abusive, defamatory, or false content. Hitch reserves the right to moderate and remove content that violates our community standards.'),
            _buildSectionTitle('9. Prohibited Conduct'),
            _buildSectionText(
                'Users are strictly prohibited from using the Platform for any illegal activities, harassment, or fraudulent documentation. Any attempt to bypass the Platform\'s payment system or share harmful content will result in immediate termination of access.'),
            _buildSectionTitle('10. Liability Disclaimer'),
            _buildSectionText(
                'Hitch serves as an intermediary to facilitate carpooling. We are not a transportation company. Hitch is not liable for accidents, personal injuries, loss of property, or the individual behavior of users. Drivers are solely responsible for their conduct and the safety of their vehicles.'),
            _buildSectionTitle('11. Governing Law'),
            _buildSectionText(
                'These Terms are governed by and construed in accordance with the laws of the jurisdiction in which Hitch operates. Any disputes shall be subject to the exclusive jurisdiction of the local courts.'),
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

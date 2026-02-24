import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/screens/registration/select_role_page.dart';


class ReviewProfilePicturePage extends StatelessWidget {
  final File imageFile;

  const ReviewProfilePicturePage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Review your picture',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Please check and make sure that your face is clearly visible.',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: ClipOval(
                  child: Image.file(
                    imageFile,
                    width: 240,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const Spacer(),

              Button(
                onPressed: () {
                  authProvider.setRegistrationProfilePicture(imageFile.path);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectRolePage(),
                    ),
                  );
                },
                text: 'Confirm picture',
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Choose another picture',
                  style: TextStyle(
                    fontFamily: 'Jokker',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

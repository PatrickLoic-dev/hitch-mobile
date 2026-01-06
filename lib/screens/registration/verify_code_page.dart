import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/enums/authflow.enum.dart';
import 'package:Hitch/navigation/main_shell.dart';
import 'package:Hitch/screens/registration/enter_name_page.dart';


class VerifyCodePage extends StatefulWidget {
  final String phoneNumber;
  final AuthFlowType authFlowType;

  const VerifyCodePage({
    super.key,
    required this.phoneNumber,
    required this.authFlowType,
  });

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  late Timer _timer;
  int _start = 300; // 5 minutes in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 300; // Reset timer
    print("Flow Type ${widget.authFlowType}");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  String get timerString {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

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
              // 1. Back button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 20),

              // 2. Title Text
              const Text(
                'We sent you an SMS',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Description Text
              Text(
                'Please enter the code we just sent to ${widget.phoneNumber}',
                style: const TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // 4. OTP Input Fields
              OtpTextField(
                numberOfFields: 6,
                // Styling for each box
                fieldWidth: 48, // Set width to 48
                fieldHeight: 48, // Set height to 48
                filled: true, // Required to set a fill color
                fillColor: const Color(0xFFF5F5F5), // Set background color to #f5f5f5
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                // Border styles
                borderColor: Colors.transparent, // Hide default border
                enabledBorderColor: Colors.transparent,
                focusedBorderColor: Colors.deepPurple, // Border color when focused

                showFieldAsBox: true,
                onSubmit: (String verificationCode) {
                  print("Verification Code is: $verificationCode");
                  // You can add auto-verification logic here
                },
              ),
              const SizedBox(height: 30),

              // 5. Resend Code Link with Timer
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      if (_start > 0) ...[
                        // MODIFICATION: Link styling for the countdown
                        TextSpan(
                          text: 'Resend code in $timerString',
                          style: const TextStyle(
                            fontFamily: 'Jokker',
                            fontSize: 14,
                            color: Colors.orange, // Text color is orange
                            decoration: TextDecoration.underline, // Underline the whole text
                          ),
                        ),
                      ] else ...[
                        // MODIFICATION: Link styling for "Resend Code"
                        TextSpan(
                          text: 'Resend Code',
                          style: const TextStyle(
                            fontFamily: 'Jokker',
                            fontSize: 14,
                            color: Colors.orange, // Text color is orange
                            decoration: TextDecoration.underline, // Underline the whole text
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Resend code tapped');
                              startTimer(); // Restart the timer
                              // TODO: Add logic to actually resend the code
                            },
                        ),
                      ]
                    ],
                  ),
                ),
              ),

              const Spacer(), // Pushes the button to the bottom

              // 6. Button at the bottom
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    print('Verify Code button pressed');
                    // TODO: Add verification logic
                    if (widget.authFlowType == AuthFlowType.register) {
                      // Si c'est un NOUVEL utilisateur, on continue le flux normal
                      print("Flux REGISTER: Navigation vers EnterNamePage.");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const EnterNamePage(),
                      ));
                    } else {
                      // Si c'est un utilisateur EXISTANT (Login), on va directement à la HomePage
                      print("Flux LOGIN: Navigation vers HomePage.");
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const MainShell()),
                            (Route<dynamic> route) => false, // Cette condition supprime toutes les routes précédentes.
                      );
                    }
                  },
                  text: 'Verify Code',
                  textStyle: const TextStyle(
                    fontFamily: 'Jokker',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

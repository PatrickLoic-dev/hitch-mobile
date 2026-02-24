import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/enums/authflow.enum.dart';
import 'package:Hitch/navigation/main_shell.dart';
import 'package:Hitch/providers/auth_provider.dart';
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
  String? _otpCode;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 300; // Reset timer
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
    _timer.cancel();
    super.dispose();
  }

  String get timerString {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'We sent you an SMS',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

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

              OtpTextField(
                numberOfFields: 6,
                fieldWidth: 48,
                fieldHeight: 48,
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                borderColor: Colors.transparent,
                enabledBorderColor: Colors.transparent,
                focusedBorderColor: Colors.deepPurple,

                showFieldAsBox: true,
                onSubmit: (String verificationCode) {
                  setState(() {
                    _otpCode = verificationCode;
                  });
                },
              ),
              const SizedBox(height: 30),

              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      if (_start > 0) ...[
                        TextSpan(
                          text: 'Resend code in $timerString',
                          style: const TextStyle(
                            fontFamily: 'Jokker',
                            fontSize: 14,
                            color: Colors.orange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ] else ...[
                        TextSpan(
                          text: 'Resend Code',
                          style: const TextStyle(
                            fontFamily: 'Jokker',
                            fontSize: 14,
                            color: Colors.orange,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Resend OTP logic
                              startTimer();
                            },
                        ),
                      ]
                    ],
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () async {
                    if (_otpCode != null) {
                      if (widget.authFlowType == AuthFlowType.register) {
                        authProvider.setRegistrationOtp(_otpCode!);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const EnterNamePage(),
                        ));
                      } else {
                        await authProvider.login(
                          int.parse(widget.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')),
                          _otpCode!,
                        );
                        if (authProvider.isLoggedIn) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const MainShell()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      }
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

// lib/main.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/enums/authflow.enum.dart';
import 'package:Hitch/navigation/driver_main_shell.dart';
import 'package:Hitch/navigation/main_shell.dart';
import 'package:Hitch/providers/user_provider.dart';
import 'package:Hitch/screens/registration/enter_number_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app with MultiProvider to handle multiple states.
    // UserProvider will manage the user's role and login status.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        // You can add other providers here if needed, e.g., TripRequestProvider
        // ChangeNotifierProvider(create: (context) => TripRequestProvider()),
      ],
      child: MaterialApp(
        title: 'Hitch',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA6EB2E)),
          fontFamily: 'Jokker',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer widget listens to changes in UserProvider.
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // If user is not logged in, show the welcome page.
        if (!userProvider.isLoggedIn) {
          return const WelcomePage();
        } else {
          // If user is logged in, show the correct shell based on their role.
          return userProvider.isDriver
              ? const DriverMainShell()
              : const MainShell();
        }
      },
    );
  }
}

// Renamed from MyHomePage to WelcomePage for clarity.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _navigateToPhoneAuth(AuthFlowType flowType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EnterNumberPage(authFlowType: flowType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset('assets/images/road.png'),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'HITCH',
                    style: TextStyle(
                      fontFamily: 'Jokker',
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Safe and Affordable Carpooling',
                    style: TextStyle(
                      fontFamily: 'Jokker',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          onPressed: () => _navigateToPhoneAuth(AuthFlowType.login),
                          text: 'Login',
                          textStyle: const TextStyle(
                            fontFamily: 'Jokker',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Button(
                          onPressed: () => _navigateToPhoneAuth(AuthFlowType.register),
                          text: 'Register',
                          textStyle: const TextStyle(
                            fontFamily: 'Jokker',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Button(
                    onPressed: () {
                      // Example of logging in as a rider.
                      // In a real app, this would happen after a successful API call.
                      Provider.of<UserProvider>(context, listen: false)
                          .login(isDriver: false);
                    },
                    text: 'Sign in with Google',
                    textStyle: const TextStyle(
                      fontFamily: 'Jokker',
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Button(
                    onPressed: () {},
                    text: 'Sign in with Apple',
                    textStyle: const TextStyle(
                      fontFamily: 'Jokker',
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Jokker',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'By continuing you agree to Hitch’s '),
                        TextSpan(
                          text: 'Terms of Use',
                          style: const TextStyle(
                            color: Colors.orange,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Navigate to Terms of Use');
                            },
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            color: Colors.orange,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Navigate to Privacy Policy');
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

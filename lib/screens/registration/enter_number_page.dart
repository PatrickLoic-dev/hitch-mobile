import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/enums/authflow.enum.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/screens/registration/verify_code_page.dart';

class EnterNumberPage extends StatefulWidget {
  final AuthFlowType authFlowType;

  const EnterNumberPage({
    super.key,
    required this.authFlowType,
  });

  @override
  State<EnterNumberPage> createState() => _EnterNumberPageState();
}

class _EnterNumberPageState extends State<EnterNumberPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+237';

  void _showAccountExistsModal(BuildContext context) {
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
              const Icon(Icons.info_outline, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'Account Already Exists',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jokker',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'An account with this phone number already exists. Please log in instead or use a different number.',
                textAlign: TextAlign.center,
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
                  },
                  text: 'Got it',
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showAccountNotFoundModal(BuildContext context) {
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
              const Icon(Icons.person_add_outlined, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Account Not Found',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jokker',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'We couldn\'t find an account with this number. Would you like to create a new one?',
                textAlign: TextAlign.center,
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
                    // Switch to registration flow
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const EnterNumberPage(authFlowType: AuthFlowType.register),
                      ),
                    );
                  },
                  text: 'Go to Registration',
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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

              Text(
                widget.authFlowType == AuthFlowType.register ? 'Enter Your Contact Details' : 'Welcome Back!',
                style: const TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                widget.authFlowType == AuthFlowType.register 
                  ? 'Enter your phone number with a valid country code so others can reach you.'
                  : 'Enter your phone number to log in to your account.',
                style: const TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (countryCode) {
                        setState(() {
                          _selectedCountryCode = countryCode.dialCode!;
                        });
                      },
                      initialSelection: 'CM',
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      favorite: const ['+237', 'CMR'],
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: authProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Button(
                        onPressed: () async {
                          if (_phoneController.text.isNotEmpty) {
                            try {
                              final fullNumber = int.parse(_selectedCountryCode.replaceAll('+', '') + _phoneController.text);
                              await authProvider.sendOtp(
                                fullNumber,
                                isRegister: widget.authFlowType == AuthFlowType.register,
                              );
                              if (mounted) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => VerifyCodePage(
                                      phoneNumber: '$_selectedCountryCode ${_phoneController.text}',
                                      authFlowType: widget.authFlowType,
                                    ),
                                  ),
                                );
                              }
                            } on AccountExistsException catch (e) {
                              print('Authentication Error: Account Already Exists - $e'); // LOGGING THE ERROR
                              if (mounted) _showAccountExistsModal(context);
                            } on AccountNotFoundException catch (e) {
                              print('Authentication Error: Account Not Found - $e'); // LOGGING THE ERROR
                              if (mounted) _showAccountNotFoundModal(context);
                            } catch (e) {
                              print('Authentication Error: Unexpected Exception - $e'); // LOGGING THE ERROR
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            }
                          }
                        },
                        text: 'Send Verification Code',
                        textStyle: const TextStyle(
                          fontFamily: 'Jokker',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}

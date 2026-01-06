import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:Hitch/components/button.dart'; // Make sure this path is correct
import 'package:Hitch/enums/authflow.enum.dart';
import 'package:Hitch/screens/registration/verify_code_page.dart'; // Make sure this path is correct'

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
  // Controller to manage the text in the phone number input field
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+237';

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
              // 1. Back button at the top
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 20),

              // 2. Title Text
              const Text(
                'Enter Your Contact Details',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Description Text
              const Text(
                'Enter your phone number with a valid country code so others can reach you.',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Country Code Picker and Phone Number Input
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
                        print("New Country selected: " + countryCode.toString());
                      },
                      // Initial selection
                      initialSelection: 'CM',
                      // Whether to show the country name
                      showCountryOnly: false,
                      // Whether to show the country's dialing code
                      showOnlyCountryWhenClosed: false,
                      // How to align the flag and text
                      alignLeft: false,
                      // Add favorite countries to the top of the list
                      favorite: const ['+237', 'CMR'],
                    ),
                    // Vertical divider for visual separation
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    // Phone Number Input Field
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                          border: InputBorder.none, // Hide the default border
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // This Spacer pushes the button to the bottom
              const Spacer(),

              // 5. Button at the bottom of the page
              SizedBox(
                width: double.infinity, // Make the button stretch
                child: Button(
                  onPressed: () {
                    String fullPhoneNumber = '$_selectedCountryCode ${_phoneController.text}';
                    print('Verification code sent to: ${_phoneController.text}');
                    // Add your logic to handle sending the code

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VerifyCodePage(
                          phoneNumber: fullPhoneNumber,
                          authFlowType: widget.authFlowType,
                        ),
                      ),
                    );
                  },
                  text: 'Send Verification Code',
                  textStyle: const TextStyle(
                      fontFamily: 'Jokker',
                      fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dispose of the controller when the widget is removed from the widget tree
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
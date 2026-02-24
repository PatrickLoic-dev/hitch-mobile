import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/providers/vehicle_provider.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _registrationController = TextEditingController();
  final _colorController = TextEditingController();
  final _seatsController = TextEditingController();
  final _comfortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch user's vehicle details on page load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
      await vehicleProvider.loadMyVehicle();
      
      if (vehicleProvider.vehicle != null) {
        final v = vehicleProvider.vehicle!;
        _modelController.text = v.model;
        _registrationController.text = v.registration;
        _colorController.text = v.color;
        _seatsController.text = v.seatNumber.toString();
        _comfortController.text = v.comfort;
      }
    });
  }

  @override
  void dispose() {
    _modelController.dispose();
    _registrationController.dispose();
    _colorController.dispose();
    _seatsController.dispose();
    _comfortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final vehicleProvider = Provider.of<VehicleProvider>(context);

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
          'My Vehicle',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
        ),
      ),
      body: vehicleProvider.isLoading && _modelController.text.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFA6EB2E)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vehicle Details',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your vehicle information to start offering rides.',
                      style: TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Jokker'),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField('Vehicle Model', _modelController, 'e.g. Toyota RAV4'),
                    _buildTextField('Registration Number', _registrationController, 'e.g. LT 123 AE'),
                    _buildTextField('Color', _colorController, 'e.g. Black'),
                    _buildTextField('Number of Seats', _seatsController, 'e.g. 4', isNumber: true),
                    _buildTextField('Comfort Level', _comfortController, 'e.g. Standard, Luxury'),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: vehicleProvider.isLoading
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFFA6EB2E)))
                          : Button(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final vehicleData = {
                                      'model': _modelController.text,
                                      'registration': _registrationController.text,
                                      'color': _colorController.text,
                                      'seat_number': int.parse(_seatsController.text),
                                      'registration_number': 0, 
                                      'comfort': _comfortController.text,
                                      'owner': authProvider.user?.accountId ?? '',
                                    };
                                    await vehicleProvider.saveVehicle(authProvider.user!.accountId, vehicleData);
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Vehicle saved successfully!')),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: ${e.toString()}')),
                                      );
                                    }
                                  }
                                }
                              },
                              text: 'Save Vehicle',
                              backgroundColor: const Color(0xFFA6EB2E),
                              foregroundColor: Colors.black,
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Jokker')),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:Hitch/providers/trip_request_provider.dart';
import 'package:Hitch/models/place_suggestion.dart';
import 'package:Hitch/screens/driver-screens/offer-ride/select_date_page.dart';

class DropoffLocationPage extends StatefulWidget {
  const DropoffLocationPage({super.key});

  @override
  State<DropoffLocationPage> createState() => _DropoffLocationPageState();
}

class _DropoffLocationPageState extends State<DropoffLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  final String _apiKey = "AIzaSyCkBS7OKtUDeK8HP0TBypZaSYZOpODldsk";
  List<PlaceSuggestion> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;

  void _onPlaceSelected(PlaceSuggestion suggestion) {
    Provider.of<TripRequestProvider>(context, listen: false).setDestination(suggestion);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const DriverSelectDatePage()),
    );
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.trim().length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    setState(() => _isLoading = true);
    final Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:CM&key=$_apiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          setState(() {
            _suggestions = (data['predictions'] as List)
                .map((p) => PlaceSuggestion.fromJson(p))
                .toList();
          });
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _fetchSuggestions(query));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where are you dropping off?',
              style: TextStyle(
                fontFamily: 'Jokker',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.gps_fixed, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Logic for current location
              },
              child: Row(
                children: [
                  const Icon(Icons.my_location, color: Colors.black),
                  const SizedBox(width: 12),
                  const Text(
                    'Use current location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'RECENT',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final s = _suggestions[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(s.mainText, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(s.secondaryText),
                          onTap: () => _onPlaceSelected(s),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

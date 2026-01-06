import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/models/place_suggestion.dart';
import 'package:Hitch/screens/rider-screens/home/trips-request/search_destination_page.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


//Providers
import 'package:provider/provider.dart';
import 'package:Hitch/providers/trip_request_provider.dart';




class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  final TextEditingController _searchController = TextEditingController();

  final String _apiKey = "AIzaSyCkBS7OKtUDeK8HP0TBypZaSYZOpODldsk";

  List<PlaceSuggestion> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;
  bool _isFetchingLocation = false;

  // Variable pour garder en mémoire le lieu sélectionné
  PlaceSuggestion? _selectedPlace;

  // Logique de sélection d'un lieu
  void _onPlaceSelected(PlaceSuggestion suggestion) {
    setState(() {
      _selectedPlace = suggestion;
      _searchController.text = suggestion.mainText;
      _suggestions = []; // Vide la liste des suggestions
      _isLoading = false;
      _debounce?.cancel(); // Annule toute recherche en cours
    });
  }

  // Navigation vers la page suivante
  void _navigateToDestinationPage() {
    if (_selectedPlace != null && mounted) {
      Provider.of<TripRequestProvider>(context, listen: false).setDeparture(_selectedPlace!);

      print('Départ confirmé et stocké : ${_selectedPlace!.mainText}');

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SearchDestinationPage(),
      ));
    }
  }

  // Logique de recherche de suggestions (API Google)
  Future<void> _fetchSuggestions(String input) async {
    // Si l'utilisateur efface du texte, on réactive le mode recherche
    if (_selectedPlace != null && input != _selectedPlace!.mainText) {
      setState(() => _selectedPlace = null);
    }

    if (input.trim().length < 2) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }

    if (mounted) setState(() => _isLoading = true);

    const String countryComponent = "country:CM";
    final Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=$countryComponent&key=$_apiKey');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 && mounted) {
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
      print("Erreur de connexion : $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Debouncer pour la saisie utilisateur
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_selectedPlace == null || query != _selectedPlace!.mainText) {
        _fetchSuggestions(query);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) setState(() {});
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Logique pour obtenir et sélectionner la position actuelle
  Future<void> _handleUseMyLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        final String mainText = place.street ?? place.name ?? 'Current Location';
        final String secondaryText = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';

        final suggestion = PlaceSuggestion(
          placeId: '',
          mainText: mainText,
          secondaryText: secondaryText,
        );

        _onPlaceSelected(suggestion); // Sélectionne le lieu au lieu de naviguer
      }
    } catch (e) {
      print("Error getting location: $e");
    } finally {
      if (mounted) setState(() => _isFetchingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- PARTIE HAUTE (recherche) ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 16),
                  const Text('Where are you leaving from?', style: TextStyle(fontFamily: 'Jokker', fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFEAEAEA), thickness: 1.5),
                  const SizedBox(height: 8),
                  _buildSearchInput(),
                ],
              ),
            ),

            // --- PARTIE CENTRALE (suggestions OU rien si un lieu est choisi) ---
            Expanded(
              child: _selectedPlace == null
                  ? Column(
                children: [
                  _buildUseMyLocationButton(),
                  if (_suggestions.isNotEmpty)
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider()),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.black))
                        : _buildSuggestionsList(),
                  ),
                ],
              )
                  : Container(), // Affiche un conteneur vide si un lieu est sélectionné
            ),

            // --- PARTIE BASSE (bouton de confirmation) ---
            if (_selectedPlace != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), // Espacement ajusté
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Button(
                    onPressed: _navigateToDestinationPage,
                    text: 'Confirm Departure',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Construit le bouton "Utiliser ma position"
  Widget _buildUseMyLocationButton() {
    return InkWell(
      onTap: _isFetchingLocation ? null : _handleUseMyLocation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            _isFetchingLocation ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5)) : const Icon(Icons.my_location, color: Colors.blueAccent),
            const SizedBox(width: 16),
            const Text('Use my current location', style: TextStyle(fontFamily: 'Jokker', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }

  // Construit le champ de saisie
  Widget _buildSearchInput() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search for a location...',
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.black),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            _searchController.clear();
            setState(() => _selectedPlace = null); // Réactive la recherche
          },
        )
            : null,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      style: const TextStyle(fontFamily: 'Jokker', fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  // Construit la liste des suggestions
  Widget _buildSuggestionsList() {
    if (_searchController.text.isNotEmpty && _suggestions.isEmpty && !_isLoading) {
      return const Center(child: Text("No results found.", style: TextStyle(color: Colors.grey, fontFamily: 'Jokker')));
    }
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return _buildSuggestionItem(
          location: suggestion.mainText,
          details: suggestion.secondaryText,
          onTap: () => _onPlaceSelected(suggestion),
        );
      },
    );
  }

  // Construit un élément de la liste
  Widget _buildSuggestionItem({required String location, required String details, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.location_pin, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location, style: const TextStyle(fontFamily: 'Jokker', fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(details, style: const TextStyle(fontFamily: 'Jokker', fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


// lib/providers/trip_request_provider.dart

import 'package:flutter/material.dart';
import 'package:Hitch/models/place_suggestion.dart';


class TripRequestProvider with ChangeNotifier {
  PlaceSuggestion? _departure;
  PlaceSuggestion? _destination;
  DateTime? _dateTime;
  int? _seatCount;

  // Getters pour lire les données
  PlaceSuggestion? get departure => _departure;
  PlaceSuggestion? get destination => _destination;
  DateTime? get dateTime => _dateTime;
  int? get seatCount => _seatCount;

  bool get isTripConfigured =>
      _departure != null && _destination != null && _dateTime != null && _seatCount != null;

  // Setters pour mettre à jour les données et notifier les auditeurs
  void setDeparture(PlaceSuggestion place) {
    _departure = place;
    notifyListeners(); // Informe les widgets qui écoutent que les données ont changé
  }

  void setDestination(PlaceSuggestion place) {
    _destination = place;
    notifyListeners();
  }

  void setDateTime(DateTime dt) {
    _dateTime = dt;
    notifyListeners();
  }

  void setSeatCount(int count) {
    _seatCount = count;
    notifyListeners();
  }

  // Pour réinitialiser le formulaire
  void clearTrip() {
    _departure = null;
    _destination = null;
    _dateTime = null;
    _seatCount = null;
    notifyListeners();
  }
}

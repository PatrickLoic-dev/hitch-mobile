import 'dart:convert';
import 'package:http/http.dart' as http;

class MapService {
  final String _apiKey = "AIzaSyCkBS7OKtUDeK8HP0TBypZaSYZOpODldsk";

  Future<double> getDistance(String originPlaceId, String destinationPlaceId) async {
    final Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=place_id:$originPlaceId&destinations=place_id:$destinationPlaceId&key=$_apiKey');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final element = data['rows'][0]['elements'][0];
          if (element['status'] == 'OK') {
            // distance.value is in meters
            final int distanceInMeters = element['distance']['value'];
            return distanceInMeters / 1000.0; // Convert to kilometers
          }
        }
      }
      print('MapService: Failed to get distance. Status: ${response.statusCode}');
      return 0.0;
    } catch (e) {
      print('MapService Error: $e');
      return 0.0;
    }
  }
}

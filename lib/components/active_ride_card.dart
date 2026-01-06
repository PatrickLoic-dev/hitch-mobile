// lib/components/active_ride_card.dart

import 'package:flutter/material.dart';

class ActiveRideCard extends StatelessWidget {
  final String pickUpLocation;
  final String dropOffLocation;
  final String dateTime;
  final String price;
  final String driverName;
  final String driverAvatar;
  final VoidCallback? onTap;

  const ActiveRideCard({
    super.key,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.dateTime,
    required this.price,
    required this.driverName,
    required this.driverAvatar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lignes de localisation
            _buildLocationRow("PICK UP", pickUpLocation),
            const SizedBox(height: 12),
            _buildLocationRow("DROP OFF", dropOffLocation),
            const SizedBox(height: 16),

            // Ligne Date, Heure et Prix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateTime,
                  style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Jokker'),
                ),
                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Jokker'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Séparateur
            const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1),
            const SizedBox(height: 16),

            // Section "On trip"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Informations sur le chauffeur
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20, // Légèrement plus petit pour cette vue
                      backgroundImage: AssetImage(driverAvatar),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      driverName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jokker', fontSize: 15),
                    ),
                  ],
                ),
                // Tag "On trip"
                _buildStatusTag(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour le tag de statut "On rides"
  Widget _buildStatusTag() {
    const Color color = Color(0xFF00C537); // Même couleur que "Completed"

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "On trip",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontFamily: 'Jokker',
          fontSize: 12,
        ),
      ),
    );
  }

  // Widget réutilisé pour afficher une ligne de localisation
  Widget _buildLocationRow(String label, String location) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Jokker', fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(fontFamily: 'Jokker'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

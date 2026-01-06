// lib/components/past_ride_card.dart

import 'package:flutter/material.dart';

// Un enum pour gérer facilement les statuts
enum RideStatus { completed, cancelled }

class PastRideCard extends StatelessWidget {
  final String pickUpLocation;
  final String dropOffLocation;
  final String dateTime;
  final String price;
  final RideStatus status;
  final VoidCallback? onTap;

  const PastRideCard({
    super.key,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.dateTime,
    required this.price,
    required this.status,
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
          children: [
            // Ligne PICK UP
            _buildLocationRow("PICK UP", pickUpLocation),
            const SizedBox(height: 12),
            // Ligne DROP OFF
            _buildLocationRow("DROP OFF", dropOffLocation),
            const SizedBox(height: 16),

            // Ligne Date, Heure et Prix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateTime,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'Jokker',
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Jokker',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Séparateur
            const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1),
            const SizedBox(height: 16),

            // Ligne Statut et bouton Rebook
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusTag(),
                _buildRebookButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget privé pour construire une ligne de localisation
  Widget _buildLocationRow(String label, String location) {
    return Row(
      children: [
        SizedBox(
          width: 80, // Espace fixe pour les labels
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontFamily: 'Jokker',
              fontWeight: FontWeight.bold,
            ),
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

  // Widget privé pour le tag de statut
  Widget _buildStatusTag() {
    final bool isCompleted = status == RideStatus.completed;
    final Color foregroundColor =
    isCompleted ? const Color(0xFF00C537) : const Color(0xFFF2640E);
    final Color backgroundColor = foregroundColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? "Completed" : "Cancelled",
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Jokker',
          fontSize: 12,
        ),
      ),
    );
  }

  // Widget privé pour le bouton "Rebook"
  Widget _buildRebookButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Logique pour re-booker la course
        print("Rebook cliqué !");
      },
      icon: const Icon(Icons.refresh, size: 18),
      label: const Text("Rebook"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Jokker',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

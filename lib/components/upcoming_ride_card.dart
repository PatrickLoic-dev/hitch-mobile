// lib/components/upcoming_ride_card.dart

import 'package:flutter/material.dart';

// Enum pour les statuts des courses à venir
enum UpcomingRideStatus { confirmed, awaiting }

class UpcomingRideCard extends StatelessWidget {
  final String pickUpLocation;
  final String dropOffLocation;
  final String dateTime;
  final String price;
  final String driverName;
  final String driverAvatar;
  final String vehicleModel;
  final String vehiclePlate;
  final UpcomingRideStatus status;
  final VoidCallback? onTap;

  const UpcomingRideCard({
    super.key,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.dateTime,
    required this.price,
    required this.driverName,
    required this.driverAvatar,
    required this.vehicleModel,
    required this.vehiclePlate,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lignes PICK UP et DROP OFF (identiques au composant précédent)
            _buildLocationRow("PICK UP", pickUpLocation),
            const SizedBox(height: 12),
            _buildLocationRow("DROP OFF", dropOffLocation),
            const SizedBox(height: 16),

            // Ligne Date, Heure et Prix (identique)
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
            const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1),
            const SizedBox(height: 16),

            // NOUVELLE SECTION : Informations sur le chauffeur
            _buildDriverInfoRow(),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1),
            const SizedBox(height: 16),

            // NOUVELLE SECTION : Tag de statut
            _buildStatusTag(),
          ],
        ),
      ),
    );
  }

  // Widget pour la nouvelle section "chauffeur"
  Widget _buildDriverInfoRow() {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 24, // 48x48
          backgroundImage: AssetImage(driverAvatar),
        ),
        const SizedBox(width: 12),
        // Colonne avec le nom et les infos du véhicule
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              driverName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jokker', fontSize: 16),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(vehicleModel, style: const TextStyle(fontFamily: 'Jokker', color: Colors.grey)),
                // Point séparateur
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(vehiclePlate, style: const TextStyle(fontFamily: 'Jokker', color: Colors.grey)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget pour le nouveau tag de statut
  Widget _buildStatusTag() {
    final bool isConfirmed = status == UpcomingRideStatus.confirmed;
    final Color foregroundColor = isConfirmed ? const Color(0xFF00C537) : const Color(0xFFF2640E);
    final Color backgroundColor = foregroundColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isConfirmed ? "Confirmed" : "Awaiting Confirmation",
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Jokker',
          fontSize: 12,
        ),
      ),
    );
  }

  // --- Widgets réutilisés de l'autre composant ---
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

import 'package:flutter/material.dart';
import 'package:Hitch/enums/trip_detail_status.enum.dart';



class TripDetailPage extends StatelessWidget {
  final TripDetailStatus status;

  // On passe le statut en paramètre pour pouvoir tester tous les affichages
  const TripDetailPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond légèrement gris pour voir les cartes
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildDriverInfoCard(context),
                  const SizedBox(height: 16),
                  _buildStatusCard(),
                  const SizedBox(height: 16),
                  _buildTripDetailsCard(),
                  const SizedBox(height: 16),
                  // La carte de paiement ne s'affiche pas si le trajet est annulé
                  if (status != TripDetailStatus.cancelled)
                    _buildPaymentCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE LA PAGE ---


  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA), width: 1.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // Le Spacer prend toute la place pour centrer le titre globalement
          const Spacer(),
          const Text(
            "RIDE DETAILS",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
          ),
          const Spacer(),
          // Espace vide pour équilibrer le IconButton et bien centrer le titre
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  /// Construit la carte d'info du chauffeur
  Widget _buildDriverInfoCard(BuildContext context) {
    // Les boutons d'action ne s'affichent que pour ces statuts
    final bool showActions = status == TripDetailStatus.awaitingConfirmation || status == TripDetailStatus.confirmed;

    return _Card(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/default-avatar.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Ride share with Loïc Patrick",
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
                ),
                SizedBox(height: 4),
                Text(
                  "Fri 18 Aug, 06:00 AM",
                  style: TextStyle(color: Colors.grey, fontFamily: 'Jokker'),
                ),
              ],
            ),
          ),
          if (showActions)
            Row(
              children: [
                _ActionButton(icon: Icons.call_rounded, onPressed: () {}),
                const SizedBox(width: 8),
                _ActionButton(icon: Icons.message_rounded, onPressed: () {}),
              ],
            ),
        ],
      ),
    );
  }

  /// Construit la carte de statut
  Widget _buildStatusCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Status", style: TextStyle(fontFamily: 'Jokker', fontWeight: FontWeight.bold)),
              _buildStatusTag(),
            ],
          ),
          // Le contenu sous le statut change en fonction de l'état
          _buildConditionalStatusContent(),
        ],
      ),
    );
  }

  /// Construit la carte des détails du trajet
  Widget _buildTripDetailsCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Trip information", style: TextStyle(fontFamily: 'Jokker', fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          // Réutilisation du widget de localisation
          _buildLocationRow("PICK UP", "Akwa, Douala"),
          const SizedBox(height: 12),
          _buildLocationRow("DROP OFF", "Bonapriso, Douala"),

          // N'affiche le reste que si le statut n'est pas "Cancelled"
          if (status != TripDetailStatus.cancelled) ...[
            const _Separator(),
            _buildDetailRow(icon: Icons.person_outline, text: "Seats", value: "2"),
            const _Separator(),
            const SizedBox(height: 16),
            _buildConditionalTripAction(),
          ],
        ],
      ),
    );
  }

  /// Construit la carte de paiement
  Widget _buildPaymentCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment", style: TextStyle(fontFamily: 'Jokker', fontWeight: FontWeight.bold, fontSize: 16)),
          const _Separator(),
          _buildDetailRow(text: "Fare (3 seats)", value: "XAF 7,500.00"),
          const SizedBox(height: 8),
          _buildDetailRow(text: "Total", value: "XAF 7,500.00", isTotal: true),
          const _Separator(),
          Row(
            children: [
              Image.asset('assets/images/om-logo.png', width: 32, height: 32),
              const SizedBox(width: 12),
              const Text("612233445", style: TextStyle(fontFamily: 'Jokker')),
              const Spacer(),
              const Text("XAF 7,500.00", style: TextStyle(fontFamily: 'Jokker', fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          // Le bouton ne s'affiche pas si le trajet est annulé
          if (status != TripDetailStatus.cancelled)
            _ActionButton(
              text: "Get receipt",
              isExpanded: true,
            ),
        ],
      ),
    );
  }

  // --- LOGIQUE CONDITIONNELLE ---

  /// Retourne le contenu sous le statut en fonction de l'état
  Widget _buildConditionalStatusContent() {
    switch (status) {
      case TripDetailStatus.awaitingConfirmation:
        return const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "Once trip is confirmed a PIN will be sent to you to acknowledge the trip with driver.",
            style: TextStyle(color: Colors.grey, fontFamily: 'Jokker'),
          ),
        );
      case TripDetailStatus.confirmed:
        return Column(
          children: [
            const _Separator(),
            Row(
              children: [
                const Text("PIN for this ride", style: TextStyle(fontFamily: 'Jokker')),
                const Spacer(),
                _PinBox("1"),
                _PinBox("2"),
                _PinBox("3"),
                _PinBox("4"),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Share this code with the driver, this helps ensure your safety.",
              style: TextStyle(color: Colors.grey, fontFamily: 'Jokker'),
            ),
          ],
        );
      case TripDetailStatus.onTrip:
        return Container(
          height: 120,
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: Text("Mini Map Placeholder")),
        );
      case TripDetailStatus.completed:
      case TripDetailStatus.cancelled:
      default:
        return const SizedBox.shrink(); // Ne rien afficher
    }
  }

  /// Retourne le bouton d'action du bas en fonction de l'état
  Widget _buildConditionalTripAction() {
    switch (status) {
      case TripDetailStatus.awaitingConfirmation:
      case TripDetailStatus.confirmed:
        return _ActionButton(text: "Cancel trip", isExpanded: true);
      case TripDetailStatus.onTrip:
        return Row(
          children: [
            Expanded(child: _ActionButton(text: "Share trip status", color: const Color(0xFFE4F9C0))),
            const SizedBox(width: 16),
            Expanded(child: _ActionButton(text: "Report an issue")),
          ],
        );
      case TripDetailStatus.completed:
        return _ActionButton(text: "Get help with this ride", isExpanded: true);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- WIDGETS DE STYLE RÉUTILISABLES ---

  /// Un Tag de statut réutilisable
  Widget _buildStatusTag() {
    String text;
    Color color;

    switch (status) {
      case TripDetailStatus.awaitingConfirmation:
        text = "Awaiting";
        color = const Color(0xFFF2640E);
        break;
      case TripDetailStatus.confirmed:
        text = "Confirmed";
        color = const Color(0xFF00C537);
        break;
      case TripDetailStatus.onTrip:
        text = "On trip";
        color = const Color(0xFF00C537);
        break;
      case TripDetailStatus.completed:
        text = "Completed";
        color = const Color(0xFF00C537);
        break;
      case TripDetailStatus.cancelled:
        text = "Cancelled";
        color = const Color(0xFFF2640E);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontFamily: 'Jokker', fontSize: 12),
      ),
    );
  }

  /// Une rangée de détail simple (ex: Prix, Sièges)
  Widget _buildDetailRow({IconData? icon, required String text, required String value, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, color: Colors.grey.shade600, size: 20), const SizedBox(width: 12)],
          Text(text, style: TextStyle(fontFamily: 'Jokker', color: isTotal ? Colors.black : Colors.grey.shade600, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          const Spacer(),
          Text(value, style: TextStyle(fontFamily: 'Jokker', fontWeight: FontWeight.bold, fontSize: isTotal ? 18: 14)),
        ],
      ),
    );
  }

  /// Une rangée de localisation (réutilisée des composants de carte)
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
                  child: Text(location, style: const TextStyle(fontFamily: 'Jokker'), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- WIDGETS COMPOSANTS PERSONNALISÉS ---

/// Carte de base avec fond blanc et bordure
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
      ),
      child: child,
    );
  }
}

/// Séparateur standard
class _Separator extends StatelessWidget {
  const _Separator();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1),
    );
  }
}

/// Boîte pour un chiffre du code PIN
class _PinBox extends StatelessWidget {
  final String number;
  const _PinBox(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 28,
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

/// Bouton d'action gris standard (ou autre couleur)
class _ActionButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final VoidCallback? onPressed;
  final bool isExpanded;
  final Color? color;

  const _ActionButton({this.icon, this.text, this.onPressed, this.isExpanded = false, this.color});

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey.shade200,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: text == null ? const EdgeInsets.all(12) : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: text == null ? const CircleBorder() : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: icon != null && text != null
          ? Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon), const SizedBox(width: 8), Text(text!)])
          : (icon != null ? Icon(icon) : Text(text!)),
    );

    return isExpanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

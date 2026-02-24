import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  bool _hitchCashEnabled = true;
  int _selectedMethodIndex = 0; // 0: Hitch Balance, 1: VISA, 2: MasterCard

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jokker',
              ),
            ),
            const SizedBox(height: 24),
            
            // Hitch Balance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4C1), // Pale lime green from design
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'XAF 5000.00',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jokker',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hitch Balance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Jokker',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA6EB2E),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add, size: 18),
                            SizedBox(width: 4),
                            Text('Add funds', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Hitch Cash Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hitch Cash',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
                ),
                Switch(
                  value: _hitchCashEnabled,
                  onChanged: (val) => setState(() => _hitchCashEnabled = val),
                  activeColor: const Color(0xFFA6EB2E),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildSelectableRow(
              index: 0,
              icon: Icons.account_balance_wallet_outlined,
              label: 'Hitch Balance',
            ),
            const SizedBox(height: 40),
            
            const Text(
              'Payment methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
            ),
            const SizedBox(height: 16),
            
            _buildSelectableRow(
              index: 1,
              icon: Icons.credit_card, // You can use Image.asset for branded icons
              label: 'VISA  •••• 5678',
              iconColor: Colors.blue.shade900,
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildSelectableRow(
              index: 2,
              icon: Icons.credit_card,
              label: '•••• 5678',
              iconColor: Colors.red,
            ),
            const SizedBox(height: 16),
            
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.black, size: 20),
              label: const Text(
                'Add payment method',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Jokker'),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
            
            const SizedBox(height: 40),
            const Text(
              'Voucher',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.black, size: 20),
              label: const Text(
                'Voucher code',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Jokker'),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableRow({required int index, required IconData icon, required String label, Color? iconColor}) {
    final isSelected = _selectedMethodIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedMethodIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.grey.shade700, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Jokker'),
            ),
            const Spacer(),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFA6EB2E) : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFA6EB2E),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

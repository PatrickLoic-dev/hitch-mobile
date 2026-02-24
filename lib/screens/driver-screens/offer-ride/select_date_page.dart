import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/trip_request_provider.dart';

class DriverSelectDatePage extends StatefulWidget {
  const DriverSelectDatePage({super.key});

  @override
  State<DriverSelectDatePage> createState() => _DriverSelectDatePageState();
}

class _DriverSelectDatePageState extends State<DriverSelectDatePage> {
  DateTime? _selectedDate;
  final DateTime _today = DateTime.now();
  late final PageController _pageController;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(_today.year, _today.month);
    _pageController = PageController(initialPage: 1200);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day) {
    if (day.isBefore(DateTime(_today.year, _today.month, _today.day))) return;
    setState(() => _selectedDate = day);
  }

  void _showSeatPickerModal(DateTime confirmedDateTime) {
    int seatCount = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'How many seats do you have available?',
                    style: TextStyle(fontFamily: 'Jokker', fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCounterBtn(Icons.remove, seatCount > 1 ? () => setModalState(() => seatCount--) : null),
                      SizedBox(width: 100, child: Text('$seatCount', textAlign: TextAlign.center, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold))),
                      _buildCounterBtn(Icons.add, seatCount < 8 ? () => setModalState(() => seatCount++) : null),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Icon(Icons.campaign, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(child: Text('We recommend putting a maximum of 2 people in the back seat to ensure everyone\'s comfort', style: TextStyle(color: Colors.grey, fontSize: 14))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      onPressed: () {
                        final p = Provider.of<TripRequestProvider>(context, listen: false);
                        p.setDateTime(confirmedDateTime);
                        p.setSeatCount(seatCount);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      text: 'Confirm',
                      backgroundColor: const Color(0xFFA6EB2E),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterBtn(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 32, color: onTap == null ? Colors.grey : Colors.black),
      ),
    );
  }

  void _showTimePickerModal() {
    TimeOfDay selectedTime = const TimeOfDay(hour: 6, minute: 0);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('What time will you like to depart?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(context: context, initialTime: selectedTime);
                      if (picked != null) setModalState(() => selectedTime = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(40)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(selectedTime.format(context), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                        const Icon(Icons.keyboard_arrow_down, size: 32, color: Colors.grey),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      onPressed: () {
                        final dt = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, selectedTime.hour, selectedTime.minute);
                        Navigator.of(modalContext).pop();
                        _showSeatPickerModal(dt);
                      },
                      text: 'Confirm',
                      backgroundColor: const Color(0xFFA6EB2E),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.of(context).pop())),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Text('When are you going?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
          const SizedBox(height: 24),
          _buildCalendar(),
          const Spacer(),
          if (_selectedDate != null) Padding(padding: const EdgeInsets.all(24), child: SizedBox(width: double.infinity, child: Button(onPressed: _showTimePickerModal, text: 'Confirm Date', backgroundColor: const Color(0xFFA6EB2E)))),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)),
        Text(DateFormat('MMMM yyyy').format(_displayedMonth), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)),
      ])),
      SizedBox(height: 280, child: PageView.builder(controller: _pageController, onPageChanged: (i) => setState(() => _displayedMonth = DateTime(_today.year, _today.month + i - 1200)), itemBuilder: (context, i) => _buildMonthGrid(DateTime(_today.year, _today.month + i - 1200)))),
    ]);
  }

  Widget _buildMonthGrid(DateTime month) {
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final first = DateTime(month.year, month.month, 1);
    final start = first.weekday - 1;
    List<Widget> widgets = List.generate(start, (_) => Container());
    for (int i = 1; i <= days; i++) {
      final d = DateTime(month.year, month.month, i);
      final isSel = _selectedDate != null && DateUtils.isSameDay(d, _selectedDate);
      final isPast = d.isBefore(DateTime(_today.year, _today.month, _today.day));
      widgets.add(GestureDetector(onTap: () => _onDaySelected(d), child: Container(margin: const EdgeInsets.all(4), decoration: isSel ? const BoxDecoration(color: Color(0xFFA6EB2E), shape: BoxShape.circle) : null, alignment: Alignment.center, child: Text('$i', style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal, color: isSel ? Colors.black : isPast ? Colors.grey.shade300 : Colors.black)))));
    }
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: GridView.count(crossAxisCount: 7, shrinkWrap: true, children: widgets));
  }
}

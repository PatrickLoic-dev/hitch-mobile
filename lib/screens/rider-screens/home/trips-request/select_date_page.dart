import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/trip_request_provider.dart';
import 'package:provider/provider.dart'; // Assurez-vous que le chemin vers votre bouton est correct

class SelectDatePage extends StatefulWidget {
  const SelectDatePage({super.key});

  @override
  State<SelectDatePage> createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  DateTime? _selectedDate;
  final DateTime _today = DateTime.now();

  late final PageController _pageController;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(_today.year, _today.month);
    _pageController = PageController(initialPage: 1200); // 1200 mois = 100 ans
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextMonth() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onDaySelected(DateTime day) {
    if (day.isBefore(DateTime(_today.year, _today.month, _today.day))) {
      return;
    }
    setState(() {
      _selectedDate = day;
    });
  }

  /// Affiche la modale pour choisir le nombre de sièges.
  void _showSeatPickerModal(DateTime confirmedDateTime) {
    int seatCount = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void incrementSeats() {
              if (seatCount < 5) {
                setModalState(() => seatCount++);
              }
            }

            void decrementSeats() {
              if (seatCount > 1) {
                setModalState(() => seatCount--);
              }
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 24,
                children: [
                  const Text(
                    'How many seats would you like?',
                    style: TextStyle(
                      fontFamily: 'Jokker',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.outlined(
                        icon: const Icon(Icons.remove),
                        onPressed: decrementSeats,
                        iconSize: 32,
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: seatCount > 1 ? Colors.black : Colors.grey.shade300),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          '$seatCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Jokker',
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton.outlined(
                        icon: const Icon(Icons.add),
                        onPressed: incrementSeats,
                        iconSize: 32,
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: seatCount < 5 ? Colors.black : Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      onPressed: () {
                        final provider = Provider.of<TripRequestProvider>(context, listen: false);
                        provider.setDateTime(confirmedDateTime);
                        provider.setSeatCount(seatCount);

                        print('Toutes les infos ont été stockées dans le provider !');

                        // 3. On ferme TOUTES les pages de sélection (modales, search_destination, search_location)
                        //    pour revenir à la page racine (HomePage).
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      text: 'Confirm',
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

  /// Affiche la modale pour choisir l'heure, puis enchaîne sur celle des sièges.
  void _showTimePickerModal() {
    TimeOfDay? selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 20,
                children: [
                  const Text(
                    'What time will you like to depart?',
                    style: TextStyle(fontFamily: 'Jokker', fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.dial,
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setModalState(() => selectedTime = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, color: Colors.grey.shade700, size: 28),
                          const SizedBox(width: 16),
                          Text(
                            selectedTime?.format(context) ?? 'Select a time',
                            style: const TextStyle(fontFamily: 'Jokker', fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      onPressed: selectedTime == null ? null : () {
                        final finalDateTime = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );
                        // 1. Ferme la modale de l'heure
                        Navigator.of(modalContext).pop();
                        // 2. Ouvre la modale des sièges
                        _showSeatPickerModal(finalDateTime);
                      },
                      text: 'Confirm',
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'When are you going?',
                    style: TextStyle(
                      fontFamily: 'Jokker',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildWeekDaysHeader(),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFEAEAEA), thickness: 1.5),
            _buildAnimatedCalendar(),
            const Spacer(),
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed: _showTimePickerModal,
                    text: 'Confirm Date',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    const weekDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekDays.map((day) => Text(day, style: const TextStyle(fontFamily: 'Jokker', fontWeight: FontWeight.bold, color: Colors.grey))).toList(),
      ),
    );
  }

  Widget _buildAnimatedCalendar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: _previousMonth),
              Text(
                '${_getMonthName(_displayedMonth.month)} ${_displayedMonth.year}',
                style: const TextStyle(fontFamily: 'Jokker', fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: _nextMonth),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (pageIndex) {
              setState(() {
                _displayedMonth = DateTime(_today.year, _today.month + pageIndex - 1200);
              });
            },
            itemBuilder: (context, pageIndex) {
              final monthToBuild = DateTime(_today.year, _today.month + pageIndex - 1200);
              return _buildMonthGrid(monthToBuild);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthGrid(DateTime month) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final int startingWeekday = firstDayOfMonth.weekday - 1;

    List<Widget> dayWidgets = List.generate(startingWeekday, (_) => Container());

    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(month.year, month.month, i);
      final isToday = DateUtils.isSameDay(day, _today);
      final isSelected = _selectedDate != null ? DateUtils.isSameDay(day, _selectedDate) : false;
      final isPast = day.isBefore(DateTime(_today.year, _today.month, _today.day));

      dayWidgets.add(
        GestureDetector(
          onTap: () => _onDaySelected(day),
          child: Container(
            decoration: isSelected ? const BoxDecoration(color: Color(0xFFA6EB2E), shape: BoxShape.circle) : null,
            alignment: Alignment.center,
            child: Text(
              '$i',
              style: TextStyle(
                fontFamily: 'Jokker',
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : isPast ? Colors.grey.shade400 : isToday ? const Color(0xFFA6EB2E) : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: dayWidgets,
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return monthNames[(month - 1) % 12];
  }
}

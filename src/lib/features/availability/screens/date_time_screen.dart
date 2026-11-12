
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/booking/providers/booking_provider.dart';
import '../../design_preferences/screens/my_design_screen.dart';
import '../providers/availability_provider.dart';
import '../../../screens/customer_dashboard_screen.dart';
import '../../../screens/my_slot_screen.dart';

class DateTimeScreen extends StatelessWidget {
  const DateTimeScreen({super.key});

  static const Color burgundy = Color(0xFF590019);
  static const Color cream = Color(0xFFF7F2E0);
  static const Color blue = Color(0xFF80AEE8);
  static const Color brown = Color(0xFF58372B);

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final availability = context.watch<AvailabilityProvider>();

    final selectedService = booking.selectedService;

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(automaticallyImplyLeading: false,
        backgroundColor: burgundy,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Date and Time',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: selectedService == null
          ? const Center(
              child: Text('Please select a service first.'),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Service',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: brown,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedService.serviceName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: brown,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'RM ${selectedService.servicePrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: burgundy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Select Appointment Date',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: brown,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildCalendar(availability),

                        const SizedBox(height: 24),

                        const Text(
                          'Available Time Slots',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: brown,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: availability.availableTimeSlots.map(
                            (time) {
                              final isSelected =
                                  availability.selectedTime == time;

                              return ChoiceChip(
                                label: Text(time),
                                selected: isSelected,
                                selectedColor: blue,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : brown,
                                  fontWeight: FontWeight.w600,
                                ),
                                onSelected:
                                    availability.selectedDate == null
                                        ? null
                                        : (_) {
                                            availability.selectTime(time);
                                          },
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: burgundy,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            burgundy.withValues(alpha: 0.35),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: availability.hasCompleteSelection
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const MyDesignScreen(),
                                ),
                              );
                            }
                          : null,
                      child: const Text(
                        'Next: My Design',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCE8F8),
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const MySlotScreen(),
                ),
                (_) => false,
              );
              break;

            case 2:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const NailMuseAiPlaceholder(),
                ),
                (_) => false,
              );
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Book Now',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'My Slot',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Nail Muse AI',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(
    AvailabilityProvider availability,
  ) {
    final now = DateTime.now();
    final displayedMonth = DateTime(now.year, now.month);

    final firstDay = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    final startingWeekday = firstDay.weekday - 1;

    final totalCells =
        ((startingWeekday + daysInMonth + 6) ~/ 7) * 7;

    const weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            '${_monthName(displayedMonth.month)} ${displayedMonth.year}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: brown,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: brown,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 4,
              mainAxisExtent: 42,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - startingWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                displayedMonth.year,
                displayedMonth.month,
                dayNumber,
              );

              final today = DateTime(
                now.year,
                now.month,
                now.day,
              );

              final isPast = date.isBefore(today);

              final selected = availability.selectedDate != null &&
                  availability.selectedDate!.year == date.year &&
                  availability.selectedDate!.month == date.month &&
                  availability.selectedDate!.day == date.day;

              return InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: isPast
                    ? null
                    : () {
                        availability.selectDate(date);
                      },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? blue : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 13,
                      color: isPast
                          ? Colors.grey.shade400
                          : selected
                              ? Colors.white
                              : brown,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}

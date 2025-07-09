import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:LogisticsMasters/features/bookings/presentation/pages/guest_selection_page.dart';

class DateSelectionPage extends StatefulWidget {
  final Hotel hotel;
  
  const DateSelectionPage({super.key, required this.hotel});

  @override
  State<DateSelectionPage> createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Hotel info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.hotel.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hotel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${widget.hotel.city}, ${widget.hotel.country}",
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.hotel.rating} (${widget.hotel.reviews.length} Reviews)",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Dates selection summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDateCard(
                    "Check-in",
                    _selectedStartDate != null
                        ? _dateFormat.format(_selectedStartDate!)
                        : "Select date",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateCard(
                    "Check-out",
                    _selectedEndDate != null
                        ? _dateFormat.format(_selectedEndDate!)
                        : "Select date",
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Calendar
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return _isSelectedDay(day);
            },
            rangeStartDay: _selectedStartDate,
            rangeEndDay: _selectedEndDate,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: ColorPalette.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
              ),
              rangeStartDecoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
              ),
              rangeHighlightColor: ColorPalette.primaryColor.withOpacity(0.1),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: ColorPalette.primaryColor),
              rightChevronIcon: Icon(Icons.chevron_right, color: ColorPalette.primaryColor),
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: _canProceed() ? () {
            _proceedToGuestSelection();
          } : null,
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(String title, String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  bool _isSelectedDay(DateTime day) {
    if (_selectedStartDate == null && _selectedEndDate == null) {
      return false;
    }
    
    if (_selectedEndDate == null) {
      return isSameDay(_selectedStartDate!, day);
    }
    
    return isSameDay(_selectedStartDate!, day) || 
           isSameDay(_selectedEndDate!, day) || 
           (day.isAfter(_selectedStartDate!) && day.isBefore(_selectedEndDate!));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedStartDate == null || _selectedEndDate != null) {
        // Primer click o reinicio de selección
        _selectedStartDate = selectedDay;
        _selectedEndDate = null;
      } else {
        // Segundo click - seleccionar fecha fin
        if (selectedDay.isBefore(_selectedStartDate!)) {
          // Si la fecha seleccionada es anterior, intercambiar
          _selectedEndDate = _selectedStartDate;
          _selectedStartDate = selectedDay;
        } else {
          _selectedEndDate = selectedDay;
        }
      }
    });
  }

  bool _canProceed() {
    return _selectedStartDate != null && _selectedEndDate != null;
  }

  void _proceedToGuestSelection() {
    // Calcular la diferencia en noches
    final int nights = _selectedEndDate!.difference(_selectedStartDate!).inDays;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuestSelectionPage(
          hotel: widget.hotel,
          checkInDate: _selectedStartDate!,
          checkOutDate: _selectedEndDate!,
          nights: nights,
        ),
      ),
    );
  }
}
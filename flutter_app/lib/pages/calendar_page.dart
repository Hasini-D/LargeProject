import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _currentMonth = DateTime(2025, DateTime.now().month, 1);
  final int _streak = 0;

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  int _daysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  Widget _buildCalendarGrid() {
    int daysInThisMonth = _daysInMonth(_currentMonth);
    int startingWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    int offset = startingWeekday % 7;
    int totalCells = offset + daysInThisMonth;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        if (index < offset) {
          return Container();
        }
        int day = index - offset + 1;
        bool isToday = (_currentMonth.month == DateTime.now().month && day == DateTime.now().day);
        Color bgColor = isToday ? Colors.yellow : Colors.grey[200]!;
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(day.toString(), style: TextStyle(color: Colors.black)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_left, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (_currentMonth.month > 1) {
                            _currentMonth = DateTime(2025, _currentMonth.month - 1, 1);
                          }
                        });
                      },
                    ),
                    Text(
                      '${_monthName(_currentMonth.month)} 2025',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (_currentMonth.month < 12) {
                            _currentMonth = DateTime(2025, _currentMonth.month + 1, 1);
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((day) => Expanded(child: Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)))))
                      .toList(),
                ),
                SizedBox(height: 10),
                _buildCalendarGrid(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Text('$_streak', style: TextStyle(fontSize: 24, color: Colors.black)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
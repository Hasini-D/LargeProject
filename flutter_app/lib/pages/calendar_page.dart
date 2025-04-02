import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _currentMonth = DateTime(2025, DateTime.now().month, 1);
  int _streak = 0;
  // Composite key: "year-month-day" for each day's status.
  Map<String, String> _dayStatus = {};
  int? _selectedDay;
  String? _selectedStatus; // Selected status for the current selected day

  // Simulated user goal; in production, this should come from the user's registration data.
  String _userGoal = "Maintain Weight";

  // Returns a unique key for a day in the current month.
  String _dayKey(int day) {
    return "${_currentMonth.year}-${_currentMonth.month}-$day";
  }

  // Returns a workout plan based on the user's goal.
  Map<String, String> _getWorkoutPlan() {
    if (_userGoal == "Lose Weight") {
      return {
        "Squats": "3x10",
        "Bench Press": "3x8",
        "Deadlift": "3x8",
        "Running": "3 miles",
      };
    } else if (_userGoal == "Weight Gain/Muscle Build") {
      return {
        "Squats": "4x8",
        "Bench Press": "4x8",
        "Deadlift": "4x8",
        "Running": "1 mile",
      };
    } else {
      // Default: Maintain Weight
      return {
        "Squats": "3x12",
        "Bench Press": "3x12",
        "Deadlift": "3x12",
        "Running": "2 miles",
      };
    }
  }

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

  // When a day is tapped, update the selected day and reset any previous status selection.
  void _onDayTapped(int day) {
    setState(() {
      _selectedDay = day;
      _selectedStatus = null;
    });
  }

  // This function is called when the user confirms their status selection.
  void _confirmStatus() {
    if (_selectedDay != null && _selectedStatus != null) {
      String key = _dayKey(_selectedDay!);
      setState(() {
        _dayStatus[key] = _selectedStatus!;
        // Update streak: Increase if "Worked Out", reset if "Missed". For "Rest Day", do not change.
        if (_selectedStatus == "Worked Out") {
          _streak++;
        } else if (_selectedStatus == "Missed") {
          _streak = 0;
        }
      });
      // Clear selection after confirmation
      setState(() {
        _selectedDay = null;
        _selectedStatus = null;
      });
    }
  }

  // Build calendar grid with composite keys to determine each day’s status.
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
        Color cellColor = isToday ? Colors.yellow : Colors.grey[200]!;
        String key = _dayKey(day);

        return GestureDetector(
          onTap: () => _onDayTapped(day),
          child: Container(
            decoration: BoxDecoration(
              color: cellColor,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(day.toString(), style: TextStyle(color: Colors.black)),
                ),
                // Status indicator dot
                if (_dayStatus.containsKey(key))
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _dayStatus[key] == "Worked Out"
                            ? Colors.green
                            : _dayStatus[key] == "Rest Day"
                                ? Colors.grey
                                : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build the "To Do" section that appears below the calendar when a day is selected.
  Widget _buildToDoSection() {
    if (_selectedDay == null) {
      return Container();
    }
    Map<String, String> plan = _getWorkoutPlan();
    // Create a formatted date string for display.
    String displayDate = "${_monthName(_currentMonth.month)} $_selectedDay, ${_currentMonth.year}";
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("To Do for $displayDate:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
          SizedBox(height: 8),
          for (var exercise in plan.entries)
            Text("${exercise.key}: ${exercise.value}", style: TextStyle(fontSize: 16, color: Colors.black)),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Select Day Status",
              border: OutlineInputBorder(),
            ),
            value: _selectedStatus,
            items: const [
              DropdownMenuItem(
                value: "Worked Out",
                child: Text("Worked Out 💪"),
              ),
              DropdownMenuItem(
                value: "Rest Day",
                child: Text("Rest Day 😌"),
              ),
              DropdownMenuItem(
                value: "Missed",
                child: Text("Missed ❌"),
              ),
            ],
            onChanged: (newValue) {
              setState(() {
                _selectedStatus = newValue;
              });
            },
          ),
          SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: _confirmStatus,
              child: Text("Confirm Status"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
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
                // Month navigation row
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
                // Days of week header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((day) => Expanded(child: Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)))))
                      .toList(),
                ),
                SizedBox(height: 10),
                // Calendar grid
                _buildCalendarGrid(),
                SizedBox(height: 20),
                // Streak counter row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Text('$_streak', style: TextStyle(fontSize: 24, color: Colors.black)),
                  ],
                ),
                // To Do section appears here when a day is selected
                _buildToDoSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

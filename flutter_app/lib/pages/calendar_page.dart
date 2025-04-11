import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // For demonstration, the year is fixed at 2025.
  DateTime _currentMonth = DateTime(2025, DateTime.now().month, 1);
  int _streak = 0;
  // Holds status for each day via a composite key.
  Map<String, String> _dayStatus = {};
  // Holds user notes for each day.
  Map<String, String> _dayNotes = {};
  int? _selectedDay;
  String? _selectedStatus; // For current day's status.
  // Simulated user goal.
  String _userGoal = "Maintain Weight";
  // Controller for notes text field.
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    // If the calendar's current month matches today's month, pre-select today's day.
    if (_currentMonth.month == DateTime.now().month) {
      _selectedDay = DateTime.now().day;
      _notesController.text = _dayNotes[_dayKey(_selectedDay!)] ?? '';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // Generate a unique key for each day.
  String _dayKey(int day) {
    return "${_currentMonth.year}-${_currentMonth.month}-$day";
  }

  // Return a workout plan based on the user's goal.
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

  // Return the month name.
  String _monthName(int month) {
    const months = [
      '',
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
      'December'
    ];
    return months[month];
  }

  // Return the number of days in the current month.
  int _daysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  // When a day is tapped, update the selection and update notes controller;
  // then immediately switch to the "To Do" tab.
  void _onDayTapped(BuildContext context, int day) {
    setState(() {
      _selectedDay = day;
      _selectedStatus = null;
      _notesController.text = _dayNotes[_dayKey(day)] ?? '';
    });
    // Switch to the "To Do" tab (Tab index 1).
    DefaultTabController.of(context)?.animateTo(1);
  }

  void _confirmStatus() async {
    print("Confirm Status Button Pressed"); // Debugging line
    if (_selectedDay != null && _selectedStatus != null) {
      String key = _dayKey(_selectedDay!);

      // Update the day status first
      setState(() {
        _dayStatus[key] = _selectedStatus!;
        // Do not set _selectedStatus to null here
      });

      // Print the selected status for debugging
      print("Selected Status: '$_selectedStatus'"); // Debugging line

      // Perform the asynchronous operation outside of setState
      if (_selectedStatus!.trim() == "Worked Out") {
        _streak++;
        print("Incrementing streak..."); // Debugging line
        await _incrementStreak(); // Call the increment streak function
      } else if (_selectedStatus!.trim() == "Missed") {
        _streak = 0;
        print("Resetting streak..."); // Debugging line
        await _resetStreak(); // Call the reset streak function
      } else {
        print("Status did not match: '$_selectedStatus'"); // Debugging line
      }

      // Now set _selectedStatus to null after processing
      setState(() {
        _selectedStatus = null; // Reset the selected status after processing
      });
    } else {
      print("Selected Day: $_selectedDay, Selected Status: $_selectedStatus"); // Debugging line
    }
  }

// Function to increment the streak
  Future<void> _incrementStreak() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final url = Uri.parse('https://fitjourneyhome.com/api/increment-streak');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user?.token}', // Include token if needed
        },
        body: json.encode({'userId': user?.id}),
      );

      if (response.statusCode == 200) {
        print('Streak incremented successfully.');
      } else {
        print('Failed to increment streak: ${response.body}');
      }
    } catch (error) {
      print('Error incrementing streak: $error');
    }
  }

// Function to reset the streak
  Future<void> _resetStreak() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final url = Uri.parse('https://fitjourneyhome.com/api/reset-streak');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user?.token}', // Include token if needed
        },
        body: json.encode({'userId': user?.id}),
      );

      if (response.statusCode == 200) {
        print('Streak reset successfully.');
      } else {
        print('Failed to reset streak: ${response.body}');
      }
    } catch (error) {
      print('Error resetting streak: $error');
    }
  }

  // Build calendar grid.
  Widget _buildCalendarGrid() {
    int daysInThisMonth = _daysInMonth(_currentMonth);
    int startingWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    int offset = startingWeekday % 7;
    int totalCells = offset + daysInThisMonth;

    return Builder(
      // Wrap in a Builder so that we can access the context below DefaultTabController.
      builder: (BuildContext context) {
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
            // Highlight the cell if it is the selected day.
            bool isSelected = (_selectedDay != null && day == _selectedDay);
            Color cellColor = isSelected ? Colors.yellow : Colors.grey[200]!;
            String key = _dayKey(day);

            return GestureDetector(
              onTap: () => _onDayTapped(context, day),
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
                    // Status indicator dot if set.
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
      },
    );
  }

  // Build the Calendar tab view.
  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Grey background for calendar area.
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            // Month navigation row.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      if (_currentMonth.month > 1) {
                        _currentMonth = DateTime(2025, _currentMonth.month - 1, 1);
                        if (_currentMonth.month == DateTime.now().month) {
                          _selectedDay = DateTime.now().day;
                        } else {
                          _selectedDay = null;
                        }
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
                        if (_currentMonth.month == DateTime.now().month) {
                          _selectedDay = DateTime.now().day;
                        } else {
                          _selectedDay = null;
                        }
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            // Days of week header.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((day) => Expanded(
                          child: Center(
                              child: Text(day,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)))))
                  .toList(),
            ),
            SizedBox(height: 10),
            // Calendar grid.
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  // Build the To Do tab view.
  Widget _buildToDoTab() {
    if (_selectedDay == null) {
      return Center(
        child: Text(
          "Select a day on the Calendar tab to view your To Do.",
          style: TextStyle(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    }
    Map<String, String> plan = _getWorkoutPlan();
    String displayDate = "${_monthName(_currentMonth.month)} $_selectedDay, ${_currentMonth.year}";
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        // White background with a thin black border.
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("To Do for $displayDate:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 8),
            for (var exercise in plan.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("${exercise.key}: ${exercise.value}",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
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
                  print("Selected Status: $_selectedStatus");
                });
              },
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: _confirmStatus,
                child: Text("Confirm Status"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Build the Notes tab view.
  Widget _buildNotesTab() {
    if (_selectedDay == null) {
      return Center(
        child: Text(
          "Select a day on the Calendar tab to add/view notes.",
          style: TextStyle(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    }
    String displayDate = "${_monthName(_currentMonth.month)} $_selectedDay, ${_currentMonth.year}";
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Notes for $displayDate:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 6,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            onChanged: (value) {
              // Save the note for the current day.
              if (_selectedDay != null) {
                _dayNotes[_dayKey(_selectedDay!)] = value;
              }
            },
            decoration: InputDecoration(
              hintText: "Enter your notes here...",
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            "Tap 'Done' on your keyboard to close it.",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Fit Journey Home Page", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "Calendar"),
              Tab(text: "To Do"),
              Tab(text: "Notes"),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Welcome message.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome, ${user?.login ?? 'User'}!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildCalendarTab(),
                    _buildToDoTab(),
                    _buildNotesTab(),
                  ],
                ),
              ),
              // Larger streak counter.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 32)),
                    SizedBox(width: 8),
                    Text('$_streak',
                        style: TextStyle(fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(FitJourneyApp());
}

class FitJourneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit Journey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomeScreen(),
        '/addFriend': (context) => AddFriendPage(),
        '/newWorkoutStep1': (context) => NewWorkoutPlanStep1(),
        '/diet': (context) => DietPage(),
        '/addMeal': (context) => AddMealPage(),
      },
    );
  }
}

// ----------------------
// Login Page
// ----------------------
class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login(BuildContext context) async {
    final String login = _usernameController.text;
    final String password = _passwordController.text;

    final url = Uri.parse('https://fitjourneyhome.com/api/login'); // Update with your API URL

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'login': login, // Send 'login' instead of 'username'
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);
        // Handle successful login (e.g., save user info, navigate to another screen)
        print('Login successful: ${data['id']}'); // You can save the user ID or other info
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle error response
        final errorData = jsonDecode(response.body);
        _errorMessage = errorData['error'] ?? 'Login failed';
        _showErrorDialog(context, _errorMessage!);
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _showErrorDialog(context, _errorMessage!);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Fit Journey',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context), // Call the login function
                child: Text('Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text('or', style: TextStyle(color: Colors.black)),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Register', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------
// Register Page
// ----------------------
class RegisterPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController  = TextEditingController();
  final TextEditingController _emailController     = TextEditingController();
  final TextEditingController _usernameController  = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Fit Journey',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------
// Add Friend Page
// ----------------------
class AddFriendPage extends StatelessWidget {
  final TextEditingController _friendUsernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Center(
                child: Text(
                  'FitJourney',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Enter Friend\'s Username',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _friendUsernameController,
                decoration: InputDecoration(
                  labelText: 'Friend\'s Username',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Friend request sent to ${_friendUsernameController.text}')),
                  );
                  Navigator.pop(context);
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------
// Friends Page
// ----------------------
class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}
class _FriendsPageState extends State<FriendsPage> {
  int _selectedLeaderboard = 0; // 0 for Friends, 1 for Global
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedLeaderboard = 0;
                      });
                    },
                    child: Text('Friends'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedLeaderboard == 0 ? Colors.blue : Colors.grey[300],
                      foregroundColor: _selectedLeaderboard == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedLeaderboard = 1;
                      });
                    },
                    child: Text('Global'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedLeaderboard == 1 ? Colors.blue : Colors.grey[300],
                      foregroundColor: _selectedLeaderboard == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addFriend');
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: _selectedLeaderboard == 0
                    ? Text('Friends Leaderboard Streaks', style: TextStyle(fontSize: 18, color: Colors.black))
                    : Text('Global Leaderboard Streaks', style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------
// My Profile Page
// ----------------------
class MyProfilePage extends StatelessWidget {
  final String currentWeight = "180 lbs";
  final String currentHeight = "70 inches";
  final String username = "john_doe";
  final String email = "john@example.com";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.monitor_weight, color: Colors.blue),
                title: Text("Current Weight", style: TextStyle(color: Colors.black)),
                trailing: Text(currentWeight,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.height, color: Colors.blue),
                title: Text("Current Height", style: TextStyle(color: Colors.black)),
                trailing: Text(currentHeight,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text("Username", style: TextStyle(color: Colors.black)),
                trailing: Text(username,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text("Email", style: TextStyle(color: Colors.black)),
                trailing: Text(email,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                child: Text("Log Out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------
// Diet (Food) Page
// ----------------------
class DietPage extends StatelessWidget {
  final List<double> calorieData = [];
  final List<double> proteinData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diet", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Calories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: calorieData.isEmpty
                      ? Text("No Data", style: TextStyle(color: Colors.black54))
                      : Text("Calories Graph"),
                ),
              ),
              SizedBox(height: 20),
              Text("Protein", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: proteinData.isEmpty
                      ? Text("No Data", style: TextStyle(color: Colors.black54))
                      : Text("Protein Graph"),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addMeal');
                },
                child: Text("Add Meal"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------
// Add Meal Page
// ----------------------
class AddMealPage extends StatefulWidget {
  @override
  _AddMealPageState createState() => _AddMealPageState();
}
class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Meal", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  controller: _mealNameController,
                  decoration: InputDecoration(
                    labelText: 'Meal Name',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Calories',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _proteinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Grams of Protein',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_mealNameController.text.isNotEmpty &&
                        _caloriesController.text.isNotEmpty &&
                        _proteinController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Meal added")),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------
// Calendar Page
// ----------------------
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

// ----------------------
// New Workout Plan – Step 1
// ----------------------
class NewWorkoutPlanStep1 extends StatefulWidget {
  @override
  _NewWorkoutPlanStep1State createState() => _NewWorkoutPlanStep1State();
}
class _NewWorkoutPlanStep1State extends State<NewWorkoutPlanStep1> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'Male';
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Workout Plan', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: <String>['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Current Height (in)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Current Weight (lbs)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Current Age (yrs)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double height = double.parse(_heightController.text);
                      double weight = double.parse(_weightController.text);
                      int age = int.parse(_ageController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewWorkoutPlanStep2(
                            gender: _selectedGender,
                            height: height,
                            weight: weight,
                            age: age,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------
// New Workout Plan – Step 2
// ----------------------
class NewWorkoutPlanStep2 extends StatefulWidget {
  final String gender;
  final double height;
  final double weight;
  final int age;
  NewWorkoutPlanStep2({
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
  });
  @override
  _NewWorkoutPlanStep2State createState() => _NewWorkoutPlanStep2State();
}
class _NewWorkoutPlanStep2State extends State<NewWorkoutPlanStep2> {
  String? _selectedGoal;
  late double bmi;
  @override
  void initState() {
    super.initState();
    bmi = (widget.weight * 703) / (widget.height * widget.height);
  }
  Color _bmiColor() {
    return (bmi >= 18.5 && bmi <= 24.9) ? Colors.green : Colors.red;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Workout Plan', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Your Current BMI Is:',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                color: _bmiColor(),
                child: Center(
                  child: Text(
                    bmi.toStringAsFixed(1),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGoal,
                hint: Text('Enter Your Desired Goal', style: TextStyle(color: Colors.black)),
                items: <String>['Lose Weight', 'Maintain Weight', 'Weight Gain/Muscle Building']
                    .map((String goal) {
                  return DropdownMenuItem<String>(
                    value: goal,
                    child: Text(goal, style: TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGoal = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedGoal != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Workout plan submitted')),
                    );
                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------
// Home Content
// ----------------------
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isNewUser = true;
    return Center(
      child: isNewUser
          ? ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/newWorkoutStep1');
              },
              child: Text('Create a New Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Today\'s Workout Plan', style: TextStyle(fontSize: 20, color: Colors.black)),
                SizedBox(height: 10),
                Text('Todo List Placeholder', style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 10),
                Text('Calories: [Placeholder]', style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 10),
                Text('Calendar View Placeholder', style: TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
    );
  }
}

// ----------------------
// Home Screen
// ----------------------
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
  HomeContent(),
  CalendarPage(),
  DietPage(), // Use DietPage() here instead of a placeholder
  FriendsPage(),
  MyProfilePage(),
];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

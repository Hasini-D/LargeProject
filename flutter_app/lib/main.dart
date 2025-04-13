import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/user_stats_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/pages/add_friend_page.dart';
import 'package:flutter_app/pages/add_meal_page.dart';
import 'package:flutter_app/pages/diet_page.dart';
import 'package:flutter_app/pages/new_workout_plan_step1.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/register_page.dart';
import 'package:flutter_app/pages/email_verification_page.dart';
import 'package:flutter_app/pages/additional_registration_page.dart';
import 'package:flutter_app/pages/motivation_page.dart';
import 'package:flutter_app/pages/calendar_page.dart';
import 'package:flutter_app/pages/profile_page.dart';

void main() {
  runApp(FitJourneyApp());
}

class FitJourneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UserStatsProvider()),
      ],
      child: MaterialApp(
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
          '/emailVerification': (context) => EmailVerificationPage(),
          '/additionalRegistration': (context) => AdditionalRegistrationPage(),
          '/home': (context) => MainTabPage(),
          '/addFriend': (context) => AddFriendPage(),
          '/newWorkoutStep1': (context) => NewWorkoutPlanStep1(),
          '/diet': (context) => DietPage(),
          '/addMeal': (context) => AddMealPage(),
        },
      ),
    );
  }
}

class MainTabPage extends StatefulWidget {
  @override
  _MainTabPageState createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    CalendarPage(),
    MotivationPage(),
    MyProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: "Motivation",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
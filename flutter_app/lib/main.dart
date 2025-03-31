import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add_friend_page.dart';
import 'package:flutter_app/pages/add_meal_page.dart';
import 'package:flutter_app/pages/diet_page.dart';
import 'package:flutter_app/pages/new_workout_plan_step1.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';

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
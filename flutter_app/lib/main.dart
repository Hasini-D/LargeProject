import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:flutter_app/models/user.dart'; // Import the User model
import 'package:flutter_app/providers/user_provider.dart'; // Import the UserProvider
import 'package:flutter_app/pages/add_friend_page.dart';
import 'package:flutter_app/pages/add_meal_page.dart';
import 'package:flutter_app/pages/diet_page.dart';
import 'package:flutter_app/pages/new_workout_plan_step1.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/email_verification_page.dart';
import 'pages/additional_registration_page.dart';

void main() {
  runApp(FitJourneyApp());
}

class FitJourneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
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
          '/home': (context) => HomeScreen(),
          '/addFriend': (context) => AddFriendPage(),
          '/newWorkoutStep1': (context) => NewWorkoutPlanStep1(),
          '/diet': (context) => DietPage(),
          '/addMeal': (context) => AddMealPage(),
        },
      ),
    );
  }
}
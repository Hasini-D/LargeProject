import 'package:flutter/material.dart';

class AdditionalRegistrationPage extends StatefulWidget {
  const AdditionalRegistrationPage({Key? key}) : super(key: key);

  @override
  _AdditionalRegistrationPageState createState() => _AdditionalRegistrationPageState();
}

class _AdditionalRegistrationPageState extends State<AdditionalRegistrationPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGoal; // for dropdown

  @override
  void initState() {
    super.initState();
    // Show the congratulations popup after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCongratulationsDialog();
    });
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Email Verified'),
        content: const Text('Congratulations, your email has been verified.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _submitAdditionalInfo() {
    // Here you would typically send the additional info (height, weight, age, goal)
    // to your API (or store them) to complete registration.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Additional information submitted')),
    );
    // After submitting, navigate to the login screen.
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Registration', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Please enter your additional details',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (inches)',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (lbs)',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age (years)',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              // Replace the text field with a dropdown for Goal
              DropdownButtonFormField<String>(
                value: _selectedGoal,
                decoration: const InputDecoration(
                  labelText: 'Select Your Goal',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Lose Weight', child: Text('Lose Weight')),
                  DropdownMenuItem(value: 'Maintain Weight', child: Text('Maintain Weight')),
                  DropdownMenuItem(value: 'Weight Gain/Muscle Build', child: Text('Weight Gain/Muscle Build')),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _selectedGoal = newValue;
                  });
                },
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitAdditionalInfo,
                child: const Text('Register'),
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

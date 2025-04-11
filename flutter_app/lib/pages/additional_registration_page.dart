import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class AdditionalRegistrationPage extends StatefulWidget {
  const AdditionalRegistrationPage({Key? key}) : super(key: key);

  @override
  _AdditionalRegistrationPageState createState() => _AdditionalRegistrationPageState();
}

class _AdditionalRegistrationPageState extends State<AdditionalRegistrationPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGoal;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    // Show the "Email Verified" popup once the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCongratulationsDialog();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Email Verified', style: TextStyle(color: Colors.black)),
        content: const Text(
          'Congratulations, your email has been verified.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _submitAdditionalInfo() {
    // Trigger the confetti animation.
    _confettiController.play();
    // Show a snackbar notification.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Additional information submitted')),
    );
    // Navigate to the login screen after a short delay to allow the confetti to play.
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Registration',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Please enter your additional details',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  // Grey box container for the additional registration form.
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // "Register" button styled as black with white text.
                  ElevatedButton(
                    onPressed: _submitAdditionalInfo,
                    child: const Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            // Confetti widget overlay positioned at the top center.
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.blue,
                  Colors.red,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

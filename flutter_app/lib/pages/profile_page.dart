import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // Default values for editable fields
  int _weight = 180;
  int _height = 70;
  int _age = 25;
  String _goal = "Maintain Weight";

  Future<void> _logout(BuildContext context) async {
    final url = Uri.parse('https://fitjourneyhome.com/api/logout');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      // Check if response is HTML error:
      if (response.body.contains('<!DOCTYPE html>') ||
          response.body.contains('Cannot POST')) {
        print('Received HTML response (error), treating logout as successful.');
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return;
      }
      
      if (response.statusCode == 200) {
        String message = "Logout successful";
        try {
          final data = jsonDecode(response.body);
          message = data['message'] ?? message;
        } catch (error) {
          print("JSON decoding failed, using default success message.");
        }
        print('Logout successful: $message');
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        String errorMessage = 'Logout failed';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['error'] ?? errorMessage;
        } catch (error) {
          errorMessage = response.body;
        }
        _showErrorDialog(context, errorMessage);
      }
    } catch (error) {
      _showErrorDialog(context, 'An error occurred: $error');
    }
  }
  
  Future<void> _deleteAccount(BuildContext context) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmDelete != true) return;
    final url = Uri.parse('https://fitjourneyhome.com/api/delete');
    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
      });
      print("DELETE request status: ${response.statusCode}");
      print("Response body: ${response.body}");
      try {
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account deleted successfully.')),
          );
          Provider.of<UserProvider>(context, listen: false).clearUser();
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else {
          _showErrorDialog(
              context, responseData['error'] ?? 'Failed to delete account');
        }
      } catch (e) {
        _showErrorDialog(context, 'Failed to parse response: ${response.body}');
      }
    } catch (error) {
      _showErrorDialog(context, 'An error occurred: $error');
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
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  
  // Dialog for editing a numeric field (weight, height, or age)
  Future<void> _editNumericField({
    required BuildContext context,
    required String title,
    required int currentValue,
    required Function(int) onSave,
    required String unit,
  }) async {
    final _controller = TextEditingController(text: currentValue.toString());
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(suffixText: unit),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              int? value = int.tryParse(_controller.text);
              if (value != null) {
                onSave(value);
                Navigator.of(ctx).pop();
              } else {
                // Optionally show an error message.
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
  
  // Dialog for editing the Goal field
  Future<void> _editGoal(BuildContext context) async {
    String tempGoal = _goal;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Goal'),
        content: DropdownButtonFormField<String>(
          value: tempGoal,
          items: const [
            DropdownMenuItem(value: "Lose Weight", child: Text("Lose Weight")),
            DropdownMenuItem(value: "Maintain Weight", child: Text("Maintain Weight")),
            DropdownMenuItem(
                value: "Gain Weight/Muscle Building",
                child: Text("Gain Weight/Muscle Building")),
          ],
          onChanged: (newValue) {
            if (newValue != null) tempGoal = newValue;
          },
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _goal = tempGoal;
              });
              Navigator.of(ctx).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Get the user from the provider (for display in header)
    final user = Provider.of<UserProvider>(context).user;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("${user?.firstName} ${user?.lastName}'s Profile", style: TextStyle(color: Colors.black)),
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
            // Username (read-only)
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text("Username", style: TextStyle(color: Colors.black)),
                trailing: Text(user?.login ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            // Weight (editable)
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.monitor_weight, color: Colors.blue),
                title: Text("Weight", style: TextStyle(color: Colors.black)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$_weight lbs", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editNumericField(
                          context: context,
                          title: "Weight",
                          currentValue: _weight,
                          unit: "lbs",
                          onSave: (value) {
                            setState(() {
                              _weight = value;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Height (editable)
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.height, color: Colors.blue),
                title: Text("Height", style: TextStyle(color: Colors.black)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$_height inches", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editNumericField(
                          context: context,
                          title: "Height",
                          currentValue: _height,
                          unit: "inches",
                          onSave: (value) {
                            setState(() {
                              _height = value;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Age (editable)
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.cake, color: Colors.blue),
                title: Text("Age", style: TextStyle(color: Colors.black)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$_age years", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editNumericField(
                          context: context,
                          title: "Age",
                          currentValue: _age,
                          unit: "years",
                          onSave: (value) {
                            setState(() {
                              _age = value;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Goal (editable via dropdown)
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.flag, color: Colors.blue),
                title: Text("Goal", style: TextStyle(color: Colors.black)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_goal, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editGoal(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Reset Password Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the reset password page.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                  );
                },
                child: Text("Reset Password"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _logout(context),
                child: Text("Log Out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _deleteAccount(context),
                child: Text("Delete Account"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
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

// A simple blank Reset Password page with an AppBar and a back button.
class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          "Reset Password Page",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}

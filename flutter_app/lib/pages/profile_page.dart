import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart'; // Import the provider package
import '../providers/user_provider.dart'; // Import your UserProvider

class MyProfilePage extends StatelessWidget {
  // Initialize with default values
  final String currentWeight = "180 lbs";
  final String currentHeight = "70 inches";

  Future<void> _logout(BuildContext context) async {
    final url = Uri.parse('https://fitjourneyhome.com/api/logout');

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        // Successfully logged out
        print('Logout successful: ${jsonDecode(response.body)['message']}');
        // Navigate to the login page or home page
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        // Handle error response
        final errorData = jsonDecode(response.body);
        _showErrorDialog(context, errorData['error'] ?? 'Logout failed');
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
    // Access the user data from the UserProvider
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
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.monitor_weight, color: Colors.blue),
                title: Text("Current Weight", style: TextStyle(color: Colors.black)),
                trailing: Text(currentWeight, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.height, color: Colors.blue),
                title: Text("Current Height", style: TextStyle(color: Colors.black)),
                trailing: Text(currentHeight, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text("Username", style: TextStyle(color: Colors.black)),
                trailing: Text(user?.login ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text("Email", style: TextStyle(color: Colors.black)),
                trailing: Text(user?.email ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
    );
  }
}
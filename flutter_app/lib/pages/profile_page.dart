import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

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
        print('Logout successful: ${jsonDecode(response.body)['message']}');
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        final errorData = jsonDecode(response.body);
        _showErrorDialog(context, errorData['error'] ?? 'Logout failed');
      }
    } catch (error) {
      _showErrorDialog(context, 'An error occurred: $error');
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
  // Ask for confirmation first
  bool? confirmDelete = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Delete Account'),
      content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirmDelete != true) {
    return; // User cancelled deletion.
  }

  final url = Uri.parse('https://fitjourneyhome.com/api/delete');

  try {
    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      // Uncomment and add your token if authentication is needed:
      // 'Authorization': 'Bearer YOUR_TOKEN_HERE',
    });

    // Debug: print status and response body
    print("DELETE request status: ${response.statusCode}");
    print("Response body: ${response.body}");

    // Try to decode the response
    try {
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account deleted successfully.')),
        );
        Provider.of<UserProvider>(context, listen: false).clearUser();
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        _showErrorDialog(context, responseData['error'] ?? 'Failed to delete account');
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
        title:
            Text("${user?.firstName} ${user?.lastName}'s Profile", style: TextStyle(color: Colors.black)),
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
                trailing: Text(user?.login ?? '',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 12.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text("Email", style: TextStyle(color: Colors.black)),
                trailing: Text(user?.email ?? '',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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

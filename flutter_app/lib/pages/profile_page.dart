import 'package:flutter/material.dart';

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
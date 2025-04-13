// leaderboard_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<dynamic> leaderboard = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    // Change the URL to your production backend endpoint.
    final url = Uri.parse('https://fitjourneyhome.com/api/leaderboard');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Limit the leaderboard to a maximum of 10 entries.
        final List<dynamic> limitedData = data.length > 10 ? data.sublist(0, 10) : data;
        setState(() {
          leaderboard = limitedData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching leaderboard';
        isLoading = false;
      });
    }
  }

  // Build the podium widget for the top three users.
  // Each now displays the user's current streak.
  Widget buildPodium(List<dynamic> topThree) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Second Place (index 1)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                topThree[1]['streaks'].toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 30,
                child: Text(
                  topThree[1]['login'][0].toUpperCase(),
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 8),
              Text(
                topThree[1]['login'] ?? 'Unknown',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          // First Place (index 0)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                topThree[0]['streaks'].toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 35,
                child: Text(
                  topThree[0]['login'][0].toUpperCase(),
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              SizedBox(height: 8),
              Text(
                topThree[0]['login'] ?? 'Unknown',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          // Third Place (index 2)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                topThree[2]['streaks'].toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: Colors.brown,
                radius: 30,
                child: Text(
                  topThree[2]['login'][0].toUpperCase(),
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 8),
              Text(
                topThree[2]['login'] ?? 'Unknown',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build the list for remaining members (starting from 4th position).
  Widget buildRemainingList(List<dynamic> remaining) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: remaining.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        // The rank for remaining entries starts at 4.
        final rank = index + 4;
        final item = remaining[index];
        return ListTile(
          leading: Text(
            rank.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          title: Text(
            item['login'] ?? 'Unknown',
            style: TextStyle(color: Colors.black),
          ),
          trailing: Text(
            item['streaks'].toString(),
            style: TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Removed AppBar to avoid extra grey area; using SafeArea to begin content at the top.
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Global Leaderboard Header with trophy icon.
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.emoji_events,
                                  size: 32,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Global Leaderboard",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Podium section for top three (if available).
                          if (leaderboard.length >= 3)
                            buildPodium(leaderboard.sublist(0, 3))
                          else
                            Container(),
                          // List of remaining members starting from position 4.
                          if (leaderboard.length > 3)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: buildRemainingList(leaderboard.sublist(3)),
                            ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

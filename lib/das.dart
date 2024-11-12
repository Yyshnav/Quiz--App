import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final int initialAnswered;
  final int initialUnanswered;
  final int totalQuestions;

  DashboardScreen({
    required this.initialAnswered,
    required this.initialUnanswered,
    required this.totalQuestions,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int answered;
  late int unanswered;

  @override
  void initState() {
    super.initState();
    // Initialize answered and unanswered questions with passed values
    answered = widget.initialAnswered;
    unanswered = widget.initialUnanswered;
  }

  void updateStats(int newAnswered) {
    setState(() {
      answered = newAnswered;
      unanswered = widget.totalQuestions -
          answered; // Recalculate unanswered based on total questions
    });
  }

  @override
  Widget build(BuildContext context) {
    // Debugging prints
    print("Answered: $answered, Unanswered: $unanswered");

    // Calculate percentage for PieChart
    double answeredPercentage = widget.totalQuestions > 0
        ? (answered / widget.totalQuestions) * 100
        : 0;
    double unansweredPercentage = widget.totalQuestions > 0
        ? (unanswered / widget.totalQuestions) * 100
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Dashboard"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Quiz Statistics",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text("Answered: $answered"),
              Text("Unanswered: $unanswered"),
              Text("Total Questions: ${widget.totalQuestions}"),
              SizedBox(height: 20),

              // PieChart Container
              Container(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.green,
                        value: answeredPercentage,
                        title: '${answeredPercentage.toStringAsFixed(1)}%',
                        radius: 50,
                        titleStyle:
                            TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: unansweredPercentage,
                        title: '${unansweredPercentage.toStringAsFixed(1)}%',
                        radius: 50,
                        titleStyle:
                            TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Logout Button inside a black container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 9),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thank You!'),
                          content: Text('You have successfully logged out.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text("Logout", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),

      // Curved Navigation Bar
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          print("Tapped index: $index");
        },
      ),
    );
  }
}

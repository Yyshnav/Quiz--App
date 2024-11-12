import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/das.dart';
import 'dart:async';
import 'package:quizapp/database_helper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import the package

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  int currentQuestionIndex = 0;
  int timerDuration = 30; // Set timer duration to 30 seconds
  Timer? _timer;
  int remainingTime = 30;

  int answered = 0;
  int unanswered = 0;
  int? selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // Load questions from the database
  Future<void> _loadQuestions() async {
    final questionList = await DatabaseHelper.instance
        .fetchQuestions(currentQuestionIndex, answered);
    setState(() {
      questions = questionList;
      unanswered = questions.length;
      isLoading = false;
    });
    if (questions.isNotEmpty) _startTimer();
  }

  void _startTimer() {
    setState(() {
      remainingTime = timerDuration;
    });

    // Ensure the timer is created only once and canceled previously if needed
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _markUnansweredAndMoveNext();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _markUnansweredAndMoveNext() {
    _stopTimer();
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        _startTimer();
      } else {
        _showQuizEndDialog();
      }
    });
  }

  void _moveToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        _stopTimer();
        currentQuestionIndex--;
        selectedOptionIndex = null;
        remainingTime = timerDuration;
        _startTimer();
      });
    }
  }

  void _answerQuestion(int selectedIndex) {
    _stopTimer();
    setState(() {
      answered++;
      if (unanswered > 0) unanswered--;
      selectedOptionIndex = selectedIndex;

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        _startTimer();
      } else {
        _showQuizEndDialog();
      }
    });
  }

  void _showQuizEndDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Completed"),
        content: Text("You have completed the quiz."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    initialAnswered: answered,
                    initialUnanswered: unanswered,
                    totalQuestions: questions.length,
                  ),
                ),
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          leading: Icon(
            Icons.arrow_back_ios_outlined,
            size: 5,
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_new_sharp),
        ),
        body: Center(child: Text("No questions available")),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final options = currentQuestion['options'].toString().split(',');

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: Icon(Icons.arrow_back_ios_new_sharp, size: 20),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              minHeight: 100.0,
              maxHeight: 100.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Flutter Quiz",
                      style: GoogleFonts.lato(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Timer in a small circle
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          "$remainingTime",
                          style: GoogleFonts.lato(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Question Section
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == currentQuestionIndex) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${currentQuestionIndex + 1}: ${currentQuestion['questionText']}",
                          style: GoogleFonts.roboto(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: options.asMap().entries.map((entry) {
                            int index = entry.key;
                            String option = entry.value;

                            bool isSelected = selectedOptionIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOptionIndex = index;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                child: Card(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color:
                                      isSelected ? Colors.green : Colors.white,
                                  elevation: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      option,
                                      style: GoogleFonts.openSans(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        // Buttons inside a container (not ElevatedButton)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _moveToPreviousQuestion,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Previous",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _markUnansweredAndMoveNext();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              },
              childCount: questions.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white), // White icons
          Icon(Icons.search, size: 30, color: Colors.white), // White icons
          Icon(Icons.settings, size: 30, color: Colors.white), // White icons
        ],
        color: Colors.black, // Black background
        buttonBackgroundColor: Colors.black, // Black button background
        backgroundColor:
            Colors.transparent, // Transparent background for the app
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          // Handle the tap events for navigation
          print("Tapped index: $index");
        },
      ),
    );
  }
}

// Sticky Header Delegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate(
      {required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

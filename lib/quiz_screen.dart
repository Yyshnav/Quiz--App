import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/Model/Provider/q.dart';
import 'package:quizapp/Model/Provider/time_provider.dart';
import 'package:quizapp/das.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/database_helper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  int currentQuestionIndex = 0;
  List<int?> selectedAnswers =
      []; // List to store selected answers for each question
  List<bool> isQuestionLocked =
      []; // Track if the question is locked (answered)
  List<bool> isAnswerSelected =
      []; // Track if an option is selected for each question

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    context.read<TimerProvider>().startTimer(30);
    context.read<TimerProvider>().onTimerExpire = _onTimerExpire;
  }

  Future<void> _loadQuestions() async {
    final questionList =
        await DatabaseHelper.instance.fetchQuestions(currentQuestionIndex, 0);
    setState(() {
      questions = questionList;
      if (questions.isNotEmpty) {
        context.read<QuizProvider>().setUnanswered(questions.length);
        selectedAnswers = List.filled(
            questions.length, null); // Initialize list for selected answers
        isQuestionLocked = List.filled(questions.length,
            false); // Initialize lock status for each question
        isAnswerSelected = List.filled(
            questions.length, false); // Initialize answer selected status
      }
      isLoading = false;
    });
  }

  // Called when the timer expires (reaches 0)
  void _onTimerExpire() {
    setState(() {
      // Lock the current question when timer expires
      isQuestionLocked[currentQuestionIndex] = true;
    });
  }

  // Move to next question
  void _moveToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        if (selectedAnswers[currentQuestionIndex] != null) {
          isQuestionLocked[currentQuestionIndex] =
              true; // Lock current question if answered
          isAnswerSelected[currentQuestionIndex] =
              true; // Mark answer as selected
        }
        currentQuestionIndex++;
        context
            .read<TimerProvider>()
            .startTimer(30); // Restart timer for the next question
      } else {
        _navigateToDashboard(); // Navigate to dashboard if it's the last question
      }
    });
  }

  // Move to previous question (view only)
  void _moveToPreviousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  // Answer the question (selection made by user)
  void _answerQuestion(int selectedIndex) {
    if (!isQuestionLocked[currentQuestionIndex]) {
      setState(() {
        selectedAnswers[currentQuestionIndex] = selectedIndex;
        isAnswerSelected[currentQuestionIndex] = true; // Mark as answered
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          initialAnswered:
              selectedAnswers.where((answer) => answer != null).length,
          initialUnanswered: questions.length -
              selectedAnswers
                  .where((answer) => answer != null)
                  .length, // This part calculates unanswered questions
          totalQuestions: questions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_outlined, size: 5),
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
        leading: Icon(Icons.arrow_back_ios_new_sharp, size: 20),
      ),
      body: Stack(
        children: [
          CustomScrollView(
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
                              "${timerProvider.remainingTime}",
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
                                int optionIndex = entry.key;
                                String option = entry.value;

                                // Disable selection if question is locked or timer expired
                                bool isSelected =
                                    selectedAnswers[currentQuestionIndex] ==
                                        optionIndex;
                                bool isOptionDisabled =
                                    isQuestionLocked[currentQuestionIndex];

                                return GestureDetector(
                                  onTap: isOptionDisabled
                                      ? null // Disable selection if locked
                                      : () {
                                          _answerQuestion(
                                              optionIndex); // Answer the question
                                        },
                                  child: Container(
                                    width: double.infinity,
                                    child: Card(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: isSelected
                                          ? Colors.green
                                          : Colors.white,
                                      elevation: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          option,
                                          style: GoogleFonts.openSans(
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
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
          // Fixed Next and Previous Buttons moved higher above the bottom
          Positioned(
            bottom: 20, // Adjust the height here to move buttons higher
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _moveToPreviousQuestion,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Previous",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _moveToNextQuestion,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        height: 50.0,
        items: const <Widget>[
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

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
    return true;
  }
}

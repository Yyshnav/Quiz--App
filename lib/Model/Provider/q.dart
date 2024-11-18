import 'package:flutter/material.dart';

class QuizProvider with ChangeNotifier {
  int _answered = 0;
  int _unanswered = 0;

  int get answered => _answered;
  int get unanswered => _unanswered;

  // Method to answer a question
  void answerQuestion() {
    _answered++;
    if (_unanswered > 0) _unanswered--;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to mark a question as unanswered
  void markUnanswered() {
    _unanswered++;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to reset the counts
  void reset() {
    _answered = 0;
    _unanswered = 0;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to set unanswered questions count
  void setUnanswered(int count) {
    _unanswered = count;
    notifyListeners();
  }
}

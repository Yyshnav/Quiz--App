import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  int _remainingTime = 30;
  Timer? _timer; // Timer object for countdown
  Function? onTimerExpire; // Callback when the timer expires

  int get remainingTime => _remainingTime;

  // Start the timer with a given duration
  void startTimer(int duration) {
    _remainingTime = duration;
    _startCountdown();
    notifyListeners();
  }

  // Stop the timer
  void stopTimer() {
    _timer?.cancel();
    notifyListeners();
  }

  // Countdown logic that runs every second
  void _startCountdown() {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners(); // Notify listeners to update UI
      } else {
        _timer?.cancel(); // Stop the timer when it reaches 0
        if (onTimerExpire != null) {
          onTimerExpire!(); // Trigger callback when timer expires
        }
      }
    });
  }

  // Reset the timer
  void resetTimer() {
    _remainingTime = 30;
    notifyListeners();
    _startCountdown();
  }
}

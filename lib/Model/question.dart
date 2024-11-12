class Question {
  final int id;
  final String questionText;
  final int answerChoicesID;

  Question({
    required this.id,
    required this.questionText,
    required this.answerChoicesID,
  });
}

class Choice {
  final int id;
  final int questionID;
  final String choiceText;

  Choice({
    required this.id,
    required this.questionID,
    required this.choiceText,
  });
}

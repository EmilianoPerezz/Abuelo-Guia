class QuestionFormatter {
  static String format(String question) {
    return question.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
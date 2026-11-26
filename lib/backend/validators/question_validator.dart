class QuestionValidator {
  static String? validate(String question) {
    final cleanedQuestion = question.trim();

    if (cleanedQuestion.isEmpty) {
      return 'Escribe una pregunta para continuar.';
    }

    if (cleanedQuestion.length > 1000) {
      return 'La pregunta no puede superar los 1000 caracteres.';
    }

    return null;
  }
}
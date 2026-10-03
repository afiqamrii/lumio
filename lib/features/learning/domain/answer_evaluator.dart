import 'learning_models.dart';

class AnswerEvaluation {
  const AnswerEvaluation({
    required this.correct,
    required this.expectedAnswer,
    required this.feedbackKey,
  });
  final bool correct;
  final Object expectedAnswer;
  final String feedbackKey;
}

abstract final class AnswerEvaluator {
  static AnswerEvaluation evaluate(LearningContent item, Object answer) {
    final (correct, expected) = switch (item) {
      MultipleChoiceContent(:final correctChoiceId) => (
        answer == correctChoiceId,
        correctChoiceId,
      ),
      AudioChoiceContent(:final correctChoiceId) => (
        answer == correctChoiceId,
        correctChoiceId,
      ),
      OrderingContent(:final correctOrder) => (
        answer is List<String> && _orderedEqual(answer, correctOrder),
        correctOrder,
      ),
      MatchContent(:final pairs) => (
        answer is Map<String, String> &&
            pairs.every((pair) => answer[pair.left] == pair.right),
        {for (final pair in pairs) pair.left: pair.right},
      ),
      BuildWordContent(:final targetWord) => (
        answer is String &&
            answer.trim().toLowerCase() == targetWord.toLowerCase(),
        targetWord,
      ),
      NumericContent(answer: final expected) => (
        answer is num && (answer - expected).abs() < 0.000001,
        expected,
      ),
    };
    return AnswerEvaluation(
      correct: correct,
      expectedAnswer: expected,
      feedbackKey: correct ? 'answer.correct' : 'answer.try_again',
    );
  }

  static bool _orderedEqual(List<String> first, List<String> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }
}

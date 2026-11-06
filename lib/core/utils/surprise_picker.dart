import 'dart:math';

/// How many surprise ideas exist; each has `surpriseIdea1`..`surpriseIdeaN`
/// texts in every language.
const int kSurpriseIdeaCount = 7;

/// Picks the next surprise idea index. When [current] is given the result is
/// always a different idea, so "roll again" never looks like it did nothing.
int nextSurpriseIndex(
  int? current,
  Random random, {
  int count = kSurpriseIdeaCount,
}) {
  if (count <= 1) return 0;
  if (current == null) return random.nextInt(count);
  final pick = random.nextInt(count - 1);
  return pick >= current ? pick + 1 : pick;
}

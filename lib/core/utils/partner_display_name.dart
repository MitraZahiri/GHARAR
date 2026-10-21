/// Names assigned when a user skips entering one ('You' / 'Ben').
const Set<String> _placeholderNames = {'you', 'ben'};

/// Returns how a partner's name should read from the other partner's side.
///
/// A placeholder like "You" is only meaningful to its owner; shown to the
/// partner it produces sentences such as "You is thinking of you", so it is
/// replaced with a neutral soulmate label.
String partnerDisplayName(String name, {required bool isTurkish}) {
  final trimmed = name.trim();
  if (trimmed.isEmpty || _placeholderNames.contains(trimmed.toLowerCase())) {
    return isTurkish ? 'Ruh Eşin' : 'Your Soulmate';
  }
  return trimmed;
}

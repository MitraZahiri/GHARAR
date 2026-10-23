import '../localization/app_localizations.dart';

const int kMaxPersonNameLength = 30;

/// Words older builds saved in place of a real name. They are display text,
/// not names, so they are stripped from stored data.
const Set<String> _placeholderNames = {
  'you',
  'ben',
  'sen',
  'partner',
  'partneriniz',
  'my soulmate',
  'your soulmate',
  'ruh eşim',
  'ruh eşin',
  'soulmate',
  'guest',
  'misafir',
};

/// Normalises a person's name for storage: trimmed, single-spaced, capped,
/// and empty when the user did not give one.
String cleanPersonName(String? raw) {
  final collapsed = (raw ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');
  if (_placeholderNames.contains(collapsed.toLowerCase())) return '';
  return collapsed.length > kMaxPersonNameLength
      ? collapsed.substring(0, kMaxPersonNameLength).trimRight()
      : collapsed;
}

/// The name to show on screen: the real name, or "You" / "Your Soulmate"
/// in the current language when none was given.
String displayPersonName(
  String? name, {
  required bool isSelf,
  required AppLocalizations loc,
}) {
  final clean = cleanPersonName(name);
  if (clean.isNotEmpty) return clean;
  return loc.t(isSelf ? 'nameYou' : 'nameYourSoulmate');
}

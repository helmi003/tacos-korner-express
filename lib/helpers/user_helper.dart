String getUserNameLetters(String fullName) {
  final parts = fullName
      .replaceFirst(RegExp(r'^[Dd]r\.?\s*'), '')
      .trim()
      .split(RegExp(r'\s+'))
      .where((e) => e.isNotEmpty)
      .toList();

  if (parts.isEmpty) return '';

  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  }

  return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
}

String getInitials(String name) {
    final parts = name
        .replaceFirst(RegExp(r'^[Dd]r\.?\s*'), '')
        .trim()
        .split(' ');
    return parts.take(2).map((w) => w.isEmpty ? '' : w[0].toUpperCase()).join();
  }

/// Derives a plausible display name from an email's local-part when there's
/// no real backend to ask, e.g. "john.doe@x.com" -> "John Doe".
String deriveNameFromEmail(String email) {
  final localPart = email.split('@').first;
  final tokens = localPart
      .split(RegExp(r'[._\-0-9]+'))
      .where((t) => t.isNotEmpty)
      .map((t) => '${t[0].toUpperCase()}${t.substring(1).toLowerCase()}')
      .toList();
  return tokens.isEmpty ? 'User' : tokens.join(' ');
}

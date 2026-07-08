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

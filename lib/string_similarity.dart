class StringSimilarity {
  static double ratio(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    s1 = s1.toLowerCase().trim();
    s2 = s2.toLowerCase().trim();

    if (s1 == s2) return 1.0;
    if (s1.contains(s2) || s2.contains(s1)) return 0.85;

    final distance = levenshteinDistance(s1, s2);
    final maxLen = s1.length > s2.length ? s1.length : s2.length;
    final similarity = 1 - (distance / maxLen);

    if (similarity > 0.6 && _hasTransposedLetters(s1, s2)) {
      return similarity + 0.1;
    }

    return similarity;
  }

  static bool _hasTransposedLetters(String a, String b) {
    if (a.length != b.length) return false;
    int transpositions = 0;
    for (int i = 0; i < a.length - 1; i++) {
      if (a[i] == b[i + 1] && a[i + 1] == b[i]) transpositions++;
    }
    return transpositions > 0;
  }

  static int levenshteinDistance(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final matrix =
        List.generate(a.length + 1, (i) => List.filled(b.length + 1, 0));

    for (var i = 0; i <= a.length; i++) matrix[i][0] = i;
    for (var j = 0; j <= b.length; j++) matrix[0][j] = j;

    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost
        ].reduce((v, e) => v < e ? v : e);
      }
    }

    return matrix[a.length][b.length];
  }

  static BestMatch findBestMatch(
      String mainString, List<String> targetStrings) {
    final ratings = targetStrings
        .map((str) => Rating(target: str, rating: ratio(mainString, str)))
        .toList();

    ratings.sort((a, b) => b.rating.compareTo(a.rating));

    return BestMatch(
      bestMatch:
          ratings.isNotEmpty ? ratings[0] : Rating(target: '', rating: 0),
      ratings: ratings,
    );
  }
}

class Rating {
  final String target;
  final double rating;

  Rating({required this.target, required this.rating});
}

class BestMatch {
  final Rating bestMatch;
  final List<Rating> ratings;

  BestMatch({required this.bestMatch, required this.ratings});
}

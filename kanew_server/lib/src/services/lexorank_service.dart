/// Service for generating LexoRank strings for ordering
///
/// LexoRank is a ranking system that allows inserting items between existing
/// ranks without needing to reindex all items. It uses alphanumeric strings
/// that can be lexicographically compared.
class LexoRankService {
  /// Alphabet used for generating ranks (base 36)
  static const String _alphabet = '0123456789abcdefghijklmnopqrstuvwxyz';

  /// Default initial rank
  static const String _initialRank = '0|hzzzzz:';

  /// Default bucket prefix
  static const String _bucket = '0|';

  /// Suffix for ranks
  static const String _suffix = ':';

  /// Generates the first rank for an empty list
  static String generateInitialRank() {
    return _initialRank;
  }

  /// Generates a rank after the given rank
  /// If [previousRank] is null, returns the initial rank
  static String generateRankAfter(String? previousRank) {
    if (previousRank == null || previousRank.isEmpty) {
      return _initialRank;
    }

    // Parse the rank to extract the value part
    final value = _extractValue(previousRank);
    final incremented = _incrementString(value);

    return '$_bucket$incremented$_suffix';
  }

  /// Generates a rank before the given rank
  static String generateRankBefore(String nextRank) {
    final value = _extractValue(nextRank);
    final decremented = _decrementString(value);

    return '$_bucket$decremented$_suffix';
  }

  /// Generates a rank between two existing ranks
  /// If [beforeRank] is null, generates before [afterRank]
  /// If [afterRank] is null, generates after [beforeRank]
  static String generateRankBetween(String? beforeRank, String? afterRank) {
    if (beforeRank == null && afterRank == null) {
      return _initialRank;
    }

    if (beforeRank == null) {
      return generateRankBefore(afterRank!);
    }

    if (afterRank == null) {
      return generateRankAfter(beforeRank);
    }

    final beforeValue = _extractValue(beforeRank);
    final afterValue = _extractValue(afterRank);

    final midValue = _midpoint(beforeValue, afterValue);

    return '$_bucket$midValue$_suffix';
  }

  /// Extracts the value part from a full rank string
  /// e.g., '0|hzzzzz:' -> 'hzzzzz'
  static String _extractValue(String rank) {
    var value = rank;

    // Remove bucket prefix
    if (value.startsWith(_bucket)) {
      value = value.substring(_bucket.length);
    }

    // Remove suffix
    if (value.endsWith(_suffix)) {
      value = value.substring(0, value.length - _suffix.length);
    }

    return value;
  }

  /// Increments a string by 1 in base-36
  static String _incrementString(String s) {
    final chars = s.split('').toList();
    var carry = true;

    for (var i = chars.length - 1; i >= 0 && carry; i--) {
      final index = _alphabet.indexOf(chars[i]);
      if (index == _alphabet.length - 1) {
        chars[i] = _alphabet[0];
        carry = true;
      } else {
        chars[i] = _alphabet[index + 1];
        carry = false;
      }
    }

    if (carry) {
      // Need to add a new character at the beginning
      return '${_alphabet[1]}${chars.join('')}';
    }

    return chars.join('');
  }

  /// Decrements a string by 1 in base-36
  static String _decrementString(String s) {
    final chars = s.split('').toList();
    var borrow = true;

    for (var i = chars.length - 1; i >= 0 && borrow; i--) {
      final index = _alphabet.indexOf(chars[i]);
      if (index == 0) {
        chars[i] = _alphabet[_alphabet.length - 1];
        borrow = true;
      } else {
        chars[i] = _alphabet[index - 1];
        borrow = false;
      }
    }

    // Remove leading zeros but keep at least one character
    var result = chars.join('');
    while (result.length > 1 && result.startsWith('0')) {
      result = result.substring(1);
    }

    return result;
  }

  /// Finds the midpoint between two strings in base-36
  static String _midpoint(String a, String b) {
    // Ensure a < b lexicographically
    if (a.compareTo(b) >= 0) {
      // If a >= b, we can't find a midpoint between them
      // This shouldn't happen in normal usage
      return _incrementString(a);
    }

    // Pad strings to same length
    final maxLen = a.length > b.length ? a.length : b.length;
    final paddedA = a.padRight(maxLen, _alphabet[0]);
    final paddedB = b.padRight(maxLen, _alphabet[0]);

    // Convert to numeric values
    final aValues = paddedA.split('').map((c) => _alphabet.indexOf(c)).toList();
    final bValues = paddedB.split('').map((c) => _alphabet.indexOf(c)).toList();

    // Calculate midpoint
    final midValues = <int>[];
    var carry = 0;

    for (var i = aValues.length - 1; i >= 0; i--) {
      final sum = aValues[i] + bValues[i] + carry;
      midValues.insert(0, (sum ~/ 2) % _alphabet.length);
      carry = sum % 2;
    }

    final result = midValues.map((v) => _alphabet[v]).join('');

    // If result equals a, we need to add more precision
    if (result == paddedA) {
      // Add a character in the middle of the alphabet
      return '${result}i';
    }

    return result;
  }
}

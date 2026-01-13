import 'package:serverpod/serverpod.dart';

/// Utility for generating URL-friendly slugs with collision handling
class SlugGenerator {
  /// Converts text to URL-friendly slug
  static String toSlug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }

  /// Generates unique slug by appending numbers if collision
  static Future<String> generateUniqueSlug(
    Session session,
    String title, {
    required Future<bool> Function(String slug) checkSlugExists,
  }) async {
    final baseSlug = toSlug(title);
    var slug = baseSlug;
    var counter = 1;

    while (await checkSlugExists(slug)) {
      slug = '$baseSlug-$counter';
      counter++;
    }

    return slug;
  }
}

class StringFormatUtils {
  static String cleanHtml(String input) {
    final withoutTags = input.replaceAll(RegExp(r'<[^>]+>'), '');
    return withoutTags
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ');
  }

  static formatCategory(String category) {
    return category.replaceFirst('>', ' > ');
  }

  static bool isValidHttpUrl(String input) {
    final uri = Uri.tryParse(input);

    if (uri == null) return false;
    if (!(uri.scheme == 'http' || uri.scheme == 'https')) return false;

    // Allow only ASCII domain names with a dot
    return uri.host.contains('.') &&
        RegExp(r'^[a-zA-Z0-9.-]+$').hasMatch(uri.host);
  }
}

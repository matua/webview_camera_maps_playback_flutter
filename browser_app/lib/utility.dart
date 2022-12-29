String formatUrl(String text) {
  if (!text.startsWith('https://')) {
    return 'https://$text';
  }
  return text;
}

bool isUrl(String url) {
  final RegExp urlPattern = RegExp(r'^(?:http|ftp)s?://' // Scheme
      r'(?:[^@\n]+?@)?' // User
      r'(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z]{2,}|' // Domain
      r'localhost|' // Localhost
      r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' // IP
      r'(?::\d+)?' // Port
      r'(?:/[^\s]*)?$'); // Path
  return urlPattern.hasMatch(url);
}

String googleSearch(String text) {
  if (isUrl(text)) {
    return formatUrl(text);
  } else {
    return 'https://www.google.com/search?q=$text';
  }
}

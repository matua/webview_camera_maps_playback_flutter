String formatUrl(String text) {
  if (!text.startsWith('https://')) {
    return 'https://$text';
  }
  return text;
}

bool isUrl(String url) {
  final RegExp urlPattern = RegExp(r'(?:[a-zA-Z][a-zA-Z\d+.-]*)'
      r'(?:\:[\d]+)?'
      r'(?:/[^\s]*)?$');
  return urlPattern.hasMatch(url);
}

String googleSearch(String text) {
  if (isUrl(text)) {
    return formatUrl(text);
  } else {
    return 'https://www.google.com/search?q=$text';
  }
}

class Epaper {
  final String name;
  final String url;
  final String category; // 'gujarati', 'rajasthan', 'english'
  final bool requiresLogin; // Whether the newspaper requires login

  Epaper({
    required this.name,
    required this.url,
    required this.category,
    this.requiresLogin = false,
  });
}

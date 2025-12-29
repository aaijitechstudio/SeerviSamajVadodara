class VedicSikshaDetail {
  final String title;
  final String subtitle;
  final String heroImage;
  final String description;
  final List<String> keyPoints;
  final List<String> imageGallery;
  final List<ResourceLink> links;
  final List<ResourceLink> videos;

  VedicSikshaDetail({
    required this.title,
    required this.subtitle,
    required this.heroImage,
    required this.description,
    required this.keyPoints,
    required this.imageGallery,
    required this.links,
    required this.videos,
  });
}

class ResourceLink {
  final String title;
  final String url;

  ResourceLink(this.title, this.url);
}

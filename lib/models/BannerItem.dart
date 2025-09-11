class BannerItem {
  final String title;
  final String bannerUrl;

  BannerItem({required this.title, required this.bannerUrl});

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(title: json['title'], bannerUrl: json['bannerUrl']);
  }
}

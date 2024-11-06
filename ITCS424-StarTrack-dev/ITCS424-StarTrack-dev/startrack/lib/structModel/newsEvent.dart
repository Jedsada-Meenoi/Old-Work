// ignore_for_file: file_names

class NewsEvent {
  final String id;
  final String banner;
  final int createdAt;
  final String description;
  final int endAt;
  final int startAt;
  final String title;
  final String url;

  const NewsEvent(
      {required this.id,
      required this.banner,
      required this.createdAt,
      required this.description,
      required this.endAt,
      required this.startAt,
      required this.title,
      required this.url});

  factory NewsEvent.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": String id,
        "banner": String banner,
        "createdAt": int createdAt,
        "description": String description,
        "endAt": int endAt,
        "startAt": int startAt,
        "title": String title,
        "url": String url,
      } =>
        NewsEvent(
            id: id,
            banner: banner,
            createdAt: createdAt,
            description: description,
            endAt: endAt,
            startAt: startAt,
            title: title,
            url: url),
      _ => throw const FormatException('FAILED TO LOAD EVENTS'),
    };
  }
}

class Motivation {
  int id;
  String content;

  Motivation({required this.id, required this.content});

  factory Motivation.fromJson(Map<String, dynamic> json) {
    return Motivation(
      id: json['id'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
    };
  }
}

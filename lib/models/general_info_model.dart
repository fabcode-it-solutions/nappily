class Topic {
  final String title;
  final String content;
  final String tagLine;

  Topic({required this.title, required this.content, required this.tagLine});

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      tagLine: map['tag_line'] ?? '',
    );
  }
}

class Section {
  final String title;
  final bool paid;
  final List<Topic> topics;

  Section({required this.title, required this.topics, required this.paid});

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      title: map['title'] ?? '',
      paid: map['paid'] ?? false,
      topics:
          (map['topics'] as List)
              .map((t) => Topic.fromMap(t as Map<String, dynamic>))
              .toList(),
    );
  }
}

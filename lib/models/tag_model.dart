class Tag {
  final String tid;

  Tag({
    required this.tid,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tid: json['tid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tid': tid,
    };
  }
}

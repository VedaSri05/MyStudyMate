class TopicModel {
  final String subjectName;

  final String topicName;

  final String difficulty;

  TopicModel({
    required this.subjectName,
    required this.topicName,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'topicName': topicName,
      'difficulty': difficulty,
    };
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      subjectName: json['subjectName'],
      topicName: json['topicName'],
      difficulty: json['difficulty'],
    );
  }
}

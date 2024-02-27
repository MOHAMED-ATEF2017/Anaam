
class Settings{
  int id;
  String type;
  String content;

  Settings({
    required this.id,
    required this.type,
    required this.content,
  });

  factory Settings.fromJson(Map<String, dynamic> json){
    return Settings(
      id: json['id'] as int,
      type: json['type'] as String,
      content: json['content'] as String,
    );
  }
}
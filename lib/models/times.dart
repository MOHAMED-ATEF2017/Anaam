class TimesModel {
  int id;
  String content;

  TimesModel({required this.id,required this.content});

  factory TimesModel.fromJson(Map<String, dynamic> json){
    return TimesModel(
      id: json['id'] as int,
      content: json['content'],
    );
  }
}
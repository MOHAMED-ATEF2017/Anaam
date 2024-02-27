class CitiesModel {
  int id;
  String title;

  CitiesModel({required this.id,required this.title});

  factory CitiesModel.fromJson(Map<String, dynamic> json){
    return CitiesModel(
      id: json['id'] as int,
      title: json['title'],
    );
  }
}
class CuttingModel {
  int id;
  String title;
  int price;

  CuttingModel({required this.id,required this.title,required this.price});

  factory CuttingModel.fromJson(Map<String, dynamic> json){
    return CuttingModel(
      id: json['id'] as int,
      title: json['title'],
      price: json['price'],
    );
  }
}
class PackagingModel {
  int id;
  String title;
  int price;

  PackagingModel({required this.id,required this.title,required this.price});

  factory PackagingModel.fromJson(Map<String, dynamic> json){
    return PackagingModel(
      id: json['id'] as int,
      title: json['title'],
      price: json['price'],
    );
  }
}
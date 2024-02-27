
import 'Size.dart';

class Product{
  int id;
  String title;
  String des;
  String image;
  List<Sizes> sizes;

  Product({
    required this.id,
    required this.title,
    required this.des,
    required this.image,
    required this.sizes,

  });

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      des: json['des'] as String,
      image: json['image'] as String,
      sizes:  List<Sizes>.from(json['sizes'].map((x) => Sizes.fromJson(x))),
    );
  }

}
class Sizes{
  int id;
  String title;
  int price;
  int quantity;

  Sizes({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });

  factory Sizes.fromJson(Map<String, dynamic> json){
    return Sizes(
      id: json['id'] as int,
      title: json['title'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
    );
  }

}
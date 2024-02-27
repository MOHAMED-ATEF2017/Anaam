
import 'package:en3am_app/models/packaging.dart';
import 'package:en3am_app/models/product.dart';

import 'Size.dart';
import 'cutting.dart';

class Cart{
  int id;
  int productId;
  int quantity;
  int sizeId;
  int sizePrice;
  Sizes size;
  int cuttingId;
  int cuttingPrice;
  CuttingModel cutting;
  int packagingId;
  int packagingPrice;
  PackagingModel packaging;
  int head;
  int rumen;
  int price;
  int mincedCount;
  int mincedPrice;
  Product product;
  String? note;

  Cart({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.sizeId,
    required this.sizePrice,
    required this.size,
    required this.cuttingId,
    required this.cuttingPrice,
    required this.cutting,
    required this.packagingId,
    required this.packagingPrice,
    required this.packaging,
    required this.head,
    required this.rumen,
    required this.price,
    required this.product,
    required this.note,
    required this.mincedCount,
    required this.mincedPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json){
    return Cart(
      id: json['id'] as int,
      productId: json['product_id'],
      quantity: json['quantity'],
      sizeId: json['size_id'],
      sizePrice: json['size_price'],
      size: Sizes.fromJson(json['size']),
      cuttingId: json['cutting_id'],
      cuttingPrice: json['cutting_price'],
      cutting: CuttingModel.fromJson(json['cutting']),
      packagingId: json['packaging_id'],
      packagingPrice: json['packaging_price'],
      packaging: PackagingModel.fromJson(json['packaging']),
      head: json['head'],
      rumen: json['rumen'],
      price: json['price'],
      note: json['note']??'',
      mincedPrice: int.parse(json['minced_price'].toString()??'0'),
      mincedCount: int.parse(json['minced_count'].toString()??'0'),
      product:  Product.fromJson(json['product']),
    );
  }

}
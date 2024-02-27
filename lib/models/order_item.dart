import 'package:en3am_app/models/packaging.dart';
import 'package:en3am_app/models/product.dart';

import 'Size.dart';
import 'cutting.dart';

class OrderItemModel {
  int id;
  int orderId;
  int productId;
  int quantity;
  int sizeId;
  int sizePrice;
  int cuttingId;
  int cuttingPrice;
  int packagingId;
  int packagingPrice;
  int head;
  int rumen;
  int price;
  String note;
  Product product;
  Sizes size;
  CuttingModel cutting;
  PackagingModel packaging;
  int mincedCount;
  int mincedPrice;


  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.sizeId,
    required this.sizePrice,
    required this.cuttingId,
    required this.cuttingPrice,
    required this.packagingId,
    required this.packagingPrice,
    required this.head,
    required this.rumen,
    required this.price,
    required this.note,
    required this.product,
    required this.size,
    required this.cutting,
    required this.packaging,
    required this.mincedCount,
    required this.mincedPrice,
});

  factory OrderItemModel.fromJson(Map<String, dynamic> json){
    return OrderItemModel(
      id: json['id'] as int,
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      sizeId: json['size_id'],
      sizePrice: json['size_price'],
      cuttingId: json['cutting_id'],
      cuttingPrice: json['cutting_price'],
      packagingId: json['packaging_id'],
      packagingPrice: json['packaging_price'],
      head: json['head'],
      rumen: json['rumen'],
      price: json['price'],
      note: json['note']??'',
      mincedPrice: int.parse(json['minced_price'].toString()??'0'),
      mincedCount: int.parse(json['minced_count'].toString()??'0'),
      product: Product.fromJson(json['product']) ,
      size: Sizes.fromJson(json['size']) ,
      cutting: CuttingModel.fromJson(json['cutting']) ,
      packaging: PackagingModel.fromJson(json['packaging']) ,
    );
  }
}
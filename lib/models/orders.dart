import 'city.dart';
import 'order_item.dart';

class OrderModel {
  int id;
  int orderNumber;
  int userId;
  int status;
  int totalPrice;
  int orderPrice;
  int deliveryFee;
  String shipName;
  String shipPhone;
  String shipAddress;
  int shipCity;
  String shipDate;
  String shipTime;
  String adminDes;
  int paymentMethod;
  String? bankName;
  String? accountName;
  String? accountIban;
  String? paymentTransactionNumber;
  String? createdAt;

  CityModel city;
  List<OrderItemModel> items;

  OrderModel(
  {
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.orderPrice,
    required this.deliveryFee,
    required this.shipName,
    required this.shipPhone,
    required this.shipAddress,
    required this.shipCity,
    required this.shipDate,
    required this.shipTime,
    required this.adminDes,
    required this.paymentMethod,
    required this.bankName,
    required this.accountName,
    required this.accountIban,
    required this.paymentTransactionNumber,
    required this.city,
    required this.items,

    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json){
    return OrderModel(
      id: json['id'] as int,
      orderNumber: json['order_number'],
      userId: json['user_id'],
      status: json['status'],
      totalPrice: json['total_price'],
      orderPrice: json['order_price'],
      deliveryFee: json['delivery_fee'],
      shipName: json['ship_name'],
      shipPhone: json['ship_phone'],
      shipAddress: json['ship_address'],
      shipCity: json['ship_city'],
      shipDate: json['ship_date'],
      shipTime: json['ship_time'],
      adminDes: json['admin_des']?? '',
      paymentMethod: json['payment_method'],
      bankName: json['bank_name'],
      accountName: json['account_name'],
      accountIban: json['account_iban'],
      city: CityModel.fromJson(json['city']),
      items: List<OrderItemModel>.from(json['items'].map((x) => OrderItemModel.fromJson(x))),
      paymentTransactionNumber: json['Payment_transaction_number'],

      createdAt: json['created_at'],
    );
  }
}
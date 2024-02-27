part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];

}

class ResetState extends OrdersEvent {}

class PlaceOrderEvent extends OrdersEvent {
  final String name;
  final String phone;
  final String address;
  final String deliveryDate;
  final int city;
  final String deliveryTime;
  final int paymentMethod;
  final String bankName;
  final String accountName;
  final String accountIban;

  const PlaceOrderEvent(
      {
        required this.name,
        required this.phone,
        required this.address,
        required this.deliveryDate,
        required this.deliveryTime,
        required this.paymentMethod,
        required this.bankName,
        required this.city,
        required this.accountName,
        required this.accountIban
      });

  @override
  List<Object> get props => [name,phone,address,deliveryDate,deliveryTime,
  paymentMethod,bankName,accountName,accountIban];
}

class GetUserOrdersEvent extends OrdersEvent {}

class GetOrderByIdEvent extends OrdersEvent {}

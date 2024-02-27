part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];

}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState{}

// place order states
class PlaceOrderDone extends OrdersState{
  final String orderNumber;

  const PlaceOrderDone({required this.orderNumber});

  @override
  List<Object> get props => [orderNumber];
}

class PlaceOrderError extends OrdersState{
  final String error;

  const PlaceOrderError({required this.error});

  @override
  List<Object> get props => [error];
}

// get user order
class LoadedUserOrder extends OrdersState{
  final List<OrderModel> data;

  const LoadedUserOrder({required this.data});

  @override
  List<Object> get props => [data];
}




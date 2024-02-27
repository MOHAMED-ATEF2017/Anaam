import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:en3am_app/models/orders.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../controller/OrdersController.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) async {
      if (event is PlaceOrderEvent) {
        emit(OrdersLoading());

        //call api
        try {
          String res = await OrdersController().placeOrder(
              event.name,
              event.phone,
              event.address,
              event.deliveryDate,
              event.city,
              event.deliveryTime,
              event.paymentMethod,
              event.bankName,
              event.accountName,
              event.accountIban);

          if (res == "error") {
            emit(const PlaceOrderError(
                error: 'لم نتمكن من ارسال الطلب، يرجى المحاولة مرة أخرى'));
          }

          var data = json.decode(res);
          if (data['success'] == false) {
            emit(PlaceOrderError(error: data['data'].toString()));
          }
          if (data['success'] == true) {
            emit(PlaceOrderDone(orderNumber: data['data'].toString()));
          }
        } catch (e) {
          emit(const PlaceOrderError(
              error: 'لم نتمكن من ارسال الطلب، يرجى المحاولة مرة أخرى'));
        }
      }

      if (event is ResetState) {
        emit(OrdersInitial());
      }

      if (event is GetUserOrdersEvent) {
        emit(OrdersLoading());
        try {
          //call api
          List<OrderModel> res = await OrdersController().getUserOrders();

          emit(LoadedUserOrder(data: res));
        } catch (e) {
          emit(const PlaceOrderError(
              error:
                  'لم نتمكن من تحميل طلبات المستخدم، يرجى المحاولة مرة أخرى'));
        }
      }
    });
  }
}

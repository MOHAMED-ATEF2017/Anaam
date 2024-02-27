import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:en3am_app/bloc/orders/orders_bloc.dart';
import 'package:en3am_app/pages/cart/cart_done.dart';
import 'package:en3am_app/pages/cart/tamara_checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tamara_flutter_sdk/tamara_sdk.dart';
import 'package:tamara_flutter_sdk/tamara_checkout.dart';
import 'tamara_checkout.dart';

import '../../bloc/bank_accounts/banks_bloc.dart';
import '../../config/colors.dart';
import '../../functions/general_function.dart';
import '../../models/banks.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';

class CartPayment extends StatefulWidget {
  final String name;
  final String phone;
  final int city;
  final String address;
  final String deliveryDate;
  final String deliveryTime;

  const CartPayment({
    Key? key,
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
    required this.deliveryDate,
    required this.deliveryTime,
  }) : super(key: key);

  @override
  State<CartPayment> createState() => _CartPaymentState();
}

class _CartPaymentState extends State<CartPayment> {
  //
  // 0 is bank transfer
  // 1 tammara
  // 2 cash
  int selectedPaymentMethod = 0;

  int selectedBank = 0;
  String bankName = '';
  String accountName = '';
  String accountIban = '';

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<OrdersBloc>(context).add(ResetState());
    BlocProvider.of<BanksBloc>(context).add(GetAccountsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(
        title: 'الدفع',
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      //details
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),

                      Expanded(
                          child: Divider(
                        thickness: 2,
                        color: AppColors.primaryColor,
                      )),
                      //shipping
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),

                      Expanded(
                          child: Divider(
                        thickness: 2,
                        color: AppColors.primaryColor,
                      )),
                      //payment
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.creditCard,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40,
                        child: Center(
                          child: Text(
                            'السلة',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Center(
                          child: Text(
                            'الشحن',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Center(
                          child: Text(
                            'الدفع',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            paymentMethods(),
            if (selectedPaymentMethod == 0) bankTransfer(),
            if (selectedPaymentMethod == 1)Center(child: AssetWidgets.loadingWidget(AppColors.primaryColor)),
          ])),

          //button
          Positioned(
            bottom: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: selectedPaymentMethod == 0
                    ? BlocConsumer<OrdersBloc, OrdersState>(
                        builder: (context, state) {
                        if (state is OrdersInitial) {
                          isLoading = false;
                          return AssetWidgets.buttonWidget(
                              context, 'ارسال الطلب', () {
                            placeOrder();
                          }, isLoading: isLoading);
                        } else if (state is OrdersLoading) {
                          isLoading = true;
                          return AssetWidgets.buttonWidget(
                              context, 'ارسال الطلب', () {
                            placeOrder();
                          }, isLoading: isLoading);
                        } else if (state is PlaceOrderError) {
                          isLoading = false;

                          return AssetWidgets.buttonWidget(
                              context, 'ارسال الطلب', () {
                            placeOrder();
                          }, isLoading: isLoading);
                        } else {
                          return const SizedBox();
                        }
                      }, listener: (context, state) {
                        if (state is PlaceOrderError) {
                          GeneralFunctions.showSnack(context, state.error);
                        }

                        if (state is PlaceOrderDone) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CartDone(
                                      orderNumber: state.orderNumber)));
                        }
                      })
                    : SizedBox.shrink()),
          ),
        ]),
      ),
    );
  }

  Widget paymentMethods() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ResponsiveGridRow(children: [
        ResponsiveGridCol(
            xs: 4,
            md: 3,
            lg: 3,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedPaymentMethod = 0;
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: selectedPaymentMethod == 0
                        ? AppColors.primaryColor
                        : Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  child: Column(children: [
                    //Icon(FontAwesomeIcons.buildingColumns,color: selectedPaymentMethod == 0?Colors.white:AppColors.primaryColor),
                    Image.asset('assets/images/icons/bank.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'تحويل بنكي',
                      style: TextStyle(
                          color: selectedPaymentMethod == 0
                              ? Colors.white
                              : AppColors.primaryColor),
                    )
                  ])),
            )),
        ResponsiveGridCol(
            xs: 4,
            md: 3,
            lg: 3,
            child: InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                const key5 = 'token';
                String? token = prefs.getString(key5);
                Logger logger = Logger();

                http.post(
                  Uri.parse("https://anaambisha.com/api/v1/orders/add"),
                  body: {
                    "token": token,
                    "ship_name": widget.name,
                    "ship_phone": widget.phone,
                    "ship_address": widget.address,
                    "ship_city": widget.city.toString(),
                    "ship_time": widget.deliveryTime,
                    "ship_date": widget.deliveryDate,
                    "payment_method": '2',
                    "bank_name": "bank name",
                    "account_name": "accountName",
                    "account_iban": "accountIban",
                  },
                  headers: {
                    // 'Content-Type': 'multipart/form-data',
                    'Accept': '*/*'
                  },
                ).then((value) {
                  Map<String, dynamic> data = json.decode(value.body);
                  logger.i(data);
                 if(data['success'] == true){

                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>  TamaraCheckoutScreen(checkoutUrl: data['data'],)));  }
                });

               
                setState(() {
                  selectedPaymentMethod = 1;
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: selectedPaymentMethod == 1
                        ? AppColors.primaryColor
                        : Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  child: Column(children: [
                    //Icon(FontAwesomeIcons.buildingColumns,color: selectedPaymentMethod == 0?Colors.white:AppColors.primaryColor),
                    Image.asset('assets/images/tamara.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'تمارا',
                      style: TextStyle(
                          color: selectedPaymentMethod == 1
                              ? Colors.white
                              : AppColors.primaryColor),
                    )
                  ])),
            )),
      ]),
    );
  }

  Widget bankTransfer() {
    return BlocBuilder<BanksBloc, BanksState>(
      builder: (context, state) {
        if (state is LoadingAccountsState) {
          return AssetWidgets.loadingWidget(AppColors.primaryColor2);
        } else if (state is LoadedAccountsState) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('يرجى تحديد الحساب البنكي الذي ترغب بالتحويل إليه'),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0; i < state.data.length; i++)
                accountBox(state.data[i]),
            ],
          );
        } else if (state is ErrorAccountsState) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget accountBox(BanksModel bank) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedBank = bank.id;
          bankName = bank.bankName;
          accountName = bank.accountName;
          accountIban = bank.iban;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              width: selectedBank == bank.id ? 2 : 0.5,
              color: selectedBank == bank.id
                  ? AppColors.primaryColor
                  : AppColors.gry1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('اسم البنك: ${bank.bankName}')),
                if (selectedBank == bank.id)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    child: const Text(
                      'تم التحديد',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Text('اسم الحساب: ${bank.accountName}')),
                InkWell(
                  onTap: () {
                    GeneralFunctions.copyText(context, bank.accountName);
                  },
                  child: const Icon(Icons.copy),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Text('رقم الحساب: ${bank.accountNumber}')),
                InkWell(
                  onTap: () {
                    GeneralFunctions.copyText(context, bank.accountNumber);
                  },
                  child: const Icon(Icons.copy),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Text('رقم الأيبان: ${bank.iban}')),
                InkWell(
                  onTap: () {
                    GeneralFunctions.copyText(context, bank.iban);
                  },
                  child: const Icon(Icons.copy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  placeOrder() {
    if (selectedBank == 0) {
      GeneralFunctions.showSnack(
          context, 'يرجى اختيار البنك الذي ترغب بالتحويل إليه');
      return;
    }

    BlocProvider.of<OrdersBloc>(context).add(PlaceOrderEvent(
      name: widget.name,
      phone: widget.phone,
      address: widget.address,
      deliveryDate: widget.deliveryDate,
      deliveryTime: widget.deliveryTime,
      paymentMethod: selectedPaymentMethod,
      bankName: bankName,
      city: widget.city,
      accountName: accountName,
      accountIban: accountIban,
    ));
  }
}

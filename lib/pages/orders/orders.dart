
import 'package:en3am_app/bloc/orders/orders_bloc.dart';
import 'package:en3am_app/functions/general_function.dart';
import 'package:en3am_app/widget/AssetsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/colors.dart';
import '../../models/orders.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';
import 'order_details.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  bool allOrders = true;
  bool currentOrders = false;
  bool doneOrders = false;

  changeTab (String tabName)
  {
    if(tabName == "allOrders")
      {
         allOrders = true;
         currentOrders = false;
         doneOrders = false;
      }

    if(tabName == "currentOrders")
    {
      allOrders = false;
      currentOrders = true;
      doneOrders = false;
    }

    if(tabName == "doneOrders")
    {
      allOrders = false;
      currentOrders = false;
      doneOrders = true;
    }

    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<OrdersBloc>(context).add(ResetState());
    BlocProvider.of<OrdersBloc>(context).add(GetUserOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: "الطلبات",cart: false,),
      bottomNavigationBar: showBottomNavBar(context, 1),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocConsumer<OrdersBloc,OrdersState>(
        listener: (context,state){
          if(state is PlaceOrderError)
          {
            GeneralFunctions.showSnack(context, state.error);
          }
        },
        builder: (context,state){
          if(state is LoadedUserOrder)
            {
              return SingleChildScrollView(
                  child: Column(
                children:  [

                  //tabs
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5,color: AppColors.gry1),
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(child: InkWell(
                            onTap: (){
                              changeTab('allOrders');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(allOrders?5:0)),
                                  color: allOrders? AppColors.primaryColor:AppColors.white
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Center(child:Text('جميع الطلبات',style: TextStyle(color: allOrders? AppColors.white:Colors.black),)),
                            )),),
                        if(doneOrders)
                          Text('|',style: TextStyle(fontSize: 18,color: AppColors.gry2),),
                        Expanded(child: InkWell(
                            onTap: (){
                              changeTab('currentOrders');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(currentOrders?5:0)),
                                  color: currentOrders? AppColors.primaryColor:AppColors.white
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Center(child:Text('قيد التنفيذ',style: TextStyle(color: currentOrders? AppColors.white:Colors.black),)),
                            )),),
                        if(allOrders)
                          Text('|',style: TextStyle(fontSize: 18,color: AppColors.gry2),),
                        Expanded(child: InkWell(
                            onTap: (){
                              changeTab('doneOrders');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(doneOrders?5:0)),
                                  color: doneOrders? AppColors.primaryColor:AppColors.white
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Center(child:Text('الطلبات المكتملة',style: TextStyle(color: doneOrders? AppColors.white:Colors.black),)),
                            )),),
                      ],
                    ),
                  ),

                  Column(
                      children: [

                          for(int i=0; i < state.data.length; i++)
                            listBox(state.data[i]),

                      ],
                    ),

                ],
              ));
            }

          if(state is PlaceOrderError)
            {
              return InkWell(
                onTap: (){
                  BlocProvider.of<OrdersBloc>(context).add(GetUserOrdersEvent());
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/sad_sheep.jpg',
                      width: MediaQuery.of(context).size.width/2,),
                      const SizedBox(height: 30,),
                      const Text('حدث خطأ، انقر هنا للمحاولة مجدداً'),
                    ],
                  ),
                ),
              );
            }

          return AssetWidgets.loadingWidget(AppColors.primaryColor);
        },
      ),




    );
  }

  Widget listBox(OrderModel order)
  {

    if(doneOrders == true && (order.status == 0 || order.status == 1))
      {
        return const SizedBox();
      }

    if(currentOrders == true && (order.status == 2 || order.status == 3))
    {
      return const SizedBox();
    }

    Color statusColor = AppColors.gry1;
    String statusText = 'بانتظار الدفع';

    if(order.status == 1)
      {
        statusText = 'قيد التنفيذ';
      }

    if(order.status == 2)
    {
      statusColor = AppColors.primaryColor2;
      statusText = 'تم التسليم';
    }

    if(order.status == 3)
    {
      statusColor = Colors.redAccent;
      statusText = 'ملغي';
    }

    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => OrderDetails(order: order,)));
      },
        child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blackColor,width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('رقم الطلب: ${order.orderNumber}',style: TextStyle(color: AppColors.blackColor,fontWeight: FontWeight.bold,fontSize: 16)),
              Text('${order.orderPrice} ر.س',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 18),),
            ],
          ),
          const SizedBox(height: 5,),
          Text('${order.shipName} - ${order.shipPhone}',style: TextStyle(fontSize: 12),),
          const SizedBox(height: 5,),
          Text('${order.city.title} - ${order.shipAddress}',style: TextStyle(fontSize: 12),),
          const SizedBox(height: 5,),


          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              const Icon(FontAwesomeIcons.clock,size: 12,),
              const SizedBox(width: 3,),
              Text(order.shipTime,style: TextStyle(color: AppColors.blackColor,fontSize: 12)),
              const SizedBox(width: 5,),
              const Icon(FontAwesomeIcons.calendar,size: 12,),
              const SizedBox(width: 3,),
              Text(order.shipDate,style: TextStyle(color: AppColors.blackColor,fontSize: 12),),
              Expanded(child: Align(alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: statusColor,
                    ),
                    child: Text(statusText,style: const TextStyle(color: Colors.white,fontSize: 13),),
                  )))
            ],
          ),


        ],
      ),
    ));
  }
}

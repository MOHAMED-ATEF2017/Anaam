

import 'package:en3am_app/bloc/cities/cities_bloc.dart';
import 'package:en3am_app/models/cities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../bloc/times/times_bloc.dart';
import '../../config/colors.dart';
import '../../functions/general_function.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import 'cart_payment.dart';

class CartShipping extends StatefulWidget {
  const CartShipping({Key? key}) : super(key: key);

  @override
  State<CartShipping> createState() => _CartShippingState();
}

class _CartShippingState extends State<CartShipping> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final DateRangePickerController _controller = DateRangePickerController();

  //Input controllers
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  //details
  int selectedTime = 0;
  String selectedTimeContent = '';
  late CitiesModel selectedCity;
  final DateTime today = DateTime.now();

  void updateSelectedTime(int data,String content) {
    setState(() {
      selectedTime = data;
      selectedTimeContent = content;
    });
  }

  Future<void> getDataFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    final userName = prefs.getString('name');
    final userPhone = prefs.getString('phone');

    _nameController.text = userName!;
    _phoneController.text = userPhone!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromLocal();

    BlocProvider.of<CitiesBloc>(context).add(GetCitiesEvent());
    BlocProvider.of<TimesBloc>(context).add(GetTimesEvent());

    _controller.selectedRange =
        PickerDateRange(today, today.add(const Duration(days: 160)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarWidget(
          title: 'الشحن',
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          //cart
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
                              FontAwesomeIcons.truckFast,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),

                          Expanded(
                              child: Divider(
                            thickness: 2,
                            color: AppColors.primaryColorDisabled,
                          )),
                          //payment
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorDisabled,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                'السلة',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.gry1),
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

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: AppColors.primaryColor,
                        )),
                        Text('  معلومات المستلم  ',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Expanded(
                            child: Divider(
                          color: AppColors.primaryColor,
                        )),
                      ],
                    )),

                //name
                const SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: const Text('الاسم ')),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: AssetWidgets.textFormWidget(
                        _nameController,
                        ' ',
                        Icon(
                          FontAwesomeIcons.user,
                          color: AppColors.primaryColor,
                        ),
                        req: true),
                  ),
                ),

                //phone
                const SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: const Text('رقم الهاتف')),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: AssetWidgets.textFormWidget(
                      _phoneController,
                      '',
                      Icon(
                        FontAwesomeIcons.phone,
                        color: AppColors.primaryColor,
                      ),
                      req: true,
                      number: true,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: AppColors.primaryColor,
                        )),
                        Text('  معلومات الشحن  ',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Expanded(
                            child: Divider(
                          color: AppColors.primaryColor,
                        )),
                      ],
                    )),

                const SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: const Text('المدينة')),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<CitiesBloc, CitiesState>(builder: (context, state) {
                  if (state is LoadingCitiesState) {
                    return AssetWidgets.loadingWidget(AppColors.primaryColor2);
                  } else if (state is LoadedCitiesState) {
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonFormField<CitiesModel>(
                          validator: (value) {
                              if (value == null) {
                                return 'مطلوب';
                              }

                            return null;
                          },
                            hint: const Text(
                              'يرجى اختيار المدينة',
                              style: TextStyle(fontSize: 15),
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesomeIcons.city,
                                color: AppColors.primaryColor,
                                size: 15,
                              ),
                              enabledBorder: OutlineInputBorder(
                                //<-- SEE HERE
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                //<-- SEE HERE
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            isExpanded: true,
                            items: state.data
                                .map<DropdownMenuItem<CitiesModel>>(
                                    (CitiesModel value) {
                              return DropdownMenuItem<CitiesModel>(
                                value: value,
                                child: Text(
                                  value.title,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedCity = value!;
                            }));
                  } else if (state is ErrorCitiesState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),

                const SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: const Text('عنوان الشحن')),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: AssetWidgets.textFormWidget(
                        _addressController,'',
                        Icon(
                          FontAwesomeIcons.solidAddressCard,
                          color: AppColors.primaryColor,
                        ),
                        req: true),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // delivery date
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: AppColors.primaryColor,
                        )),
                        Text('  تاريخ التوصيل  ',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Expanded(
                            child: Divider(
                          color: AppColors.primaryColor,
                        )),
                      ],
                    )),

                Center(
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: SfDateRangePicker(
                          controller: _controller,
                          minDate: today,
                          selectionMode: DateRangePickerSelectionMode.single,
                        ))),

                //delivery time

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: AppColors.primaryColor,
                        )),
                        Text('  وقت التوصيل  ',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Expanded(
                            child: Divider(
                          color: AppColors.primaryColor,
                        )),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<TimesBloc, TimesState>(builder: (context, state) {
                  if (state is LoadingTimesState) {
                    return AssetWidgets.loadingWidget(AppColors.primaryColor2);
                  } else if (state is LoadedTimesState) {
                    return Column(
                      children: [
                        for (var item in state.data)
                          InkWell(
                              onTap: () => updateSelectedTime(item.id,item.content),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: item.id == selectedTime
                                        ? AppColors.softColor
                                        : AppColors.white,
                                    border: Border.all(
                                        color: item.id == selectedTime
                                            ? AppColors.primaryColor
                                            : AppColors.gry1,
                                        width: item.id == selectedTime
                                            ? 1.5
                                            : 0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: Text(
                                  item.content,
                                  style: TextStyle(
                                      color: item.id == selectedTime
                                          ? AppColors.primaryColor
                                          : AppColors.blackColor),
                                ),
                              )),
                      ],
                    );
                  } else if (state is ErrorTimesState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),

                const SizedBox(
                  height: 100,
                ),
              ]),
            )),

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
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    child: AssetWidgets.buttonWidget(context, 'التالي', () {nextPage();},))),
          ]),
        ));
  }

  void nextPage(){
    if (_formKey.currentState!.validate()) {
      if(selectedTime == 0)
        {
          GeneralFunctions.showSnack(context, 'يرجى تحديد وقت التوصيل');
          return;
        }
      if(_controller.selectedDate == null)
        {
          GeneralFunctions.showSnack(context, 'يرجى تحديد تاريخ التوصيل');
          return;
        }
      if (kDebugMode) {
        print(_controller.selectedDate.toString());
      }

      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => CartPayment(
            name: _nameController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            city: selectedCity.id,
            deliveryTime: selectedTimeContent,
            deliveryDate: _controller.selectedDate.toString(),
          )));
    }else{
      GeneralFunctions.showSnack(context, 'يرجى تعبئة الحقول المطلوبة');
      return;
    }
  }
}

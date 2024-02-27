

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/cities/cities_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../config/colors.dart';
import '../../functions/general_function.dart';
import '../../models/cities.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  CitiesModel? selectedCity;

  String userName = "";
  String address = "";
  int cityId = 0;

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    userName = prefs.getString('name') ?? '';
    address = prefs.getString('address') ?? '';
    cityId = prefs.getInt('city_id') ?? 0;


    if (context.mounted) {
      setState(() {
        _nameController.text = userName;
        _addressController.text = address;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    BlocProvider.of<CitiesBloc>(context).add(GetCitiesEvent());
    BlocProvider.of<UserBloc>(context).add(SetToInitState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'الملف الشخصي',cart: false,),
      bottomNavigationBar: showBottomNavBar(context, 2),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width,
              color: AppColors.primaryColor,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: -40,
                    child: Center(
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 45,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Image.asset('assets/images/logo.png'),
                            ))),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            const Center(
              child: Text(
                'تعديل الملف الشخصي',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Padding(padding:  EdgeInsets.all(10),
              child:Text(
                'الاسم',
                style: TextStyle(fontSize: 14),
              )),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: AssetWidgets.textFormWidget(_nameController, '', const Icon(FontAwesomeIcons.user))),

            const Padding(padding:  EdgeInsets.all(10),
                child:Text(
                  'العنوان',
                  style: TextStyle(fontSize: 14),
                )),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: AssetWidgets.textFormWidget(_addressController, '', const Icon(FontAwesomeIcons.user))),

            const Padding(padding:  EdgeInsets.all(10),
                child:Text(
                  'المدينة',
                  style: TextStyle(fontSize: 14),
                )),

            BlocConsumer<CitiesBloc, CitiesState>(
                listener: (context, state) {
                  if (state is LoadedCitiesState){
                    if(selectedCity == null)
                      {
                        for(CitiesModel x in state.data)
                          {
                            if (x.id == cityId){
                              selectedCity = x;
                            }
                          }
                      }
                  }
                },
                builder: (context, state) {
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


            const SizedBox(height: 10,),
            BlocConsumer<UserBloc,UserState>(
                builder: (context,state){
                  if(state is UserInitial || state is UserErrorEvent || state is UserDoneEvent)
                    {
                      return InkWell(
                        onTap: (){
                          if(selectedCity == null)
                          {
                            GeneralFunctions.showSnack(context, 'يرجى اختيار المدينة ');
                            return;
                          }
                          if(_nameController.text.isEmpty )
                          {
                            GeneralFunctions.showSnack(context, 'يرجى كتابة الاسم ');
                            return;
                          }
                          if(_addressController.text.isEmpty )
                          {
                            GeneralFunctions.showSnack(context, 'يرجى كتابة العنوان ');
                            return;
                          }

                          BlocProvider.of<UserBloc>(context).add(UpdateUserDataEvent(cityId: selectedCity!.id.toString(), name: _nameController.text, address: _addressController.text,));

                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(10),
                          height: 45,
                          width: MediaQuery.of(context).size.width ,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                              child: Text(
                                'تحديث',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      );
                    }
                  else if(state is UserLoadingState )
                    {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        height: 45,
                        width: MediaQuery.of(context).size.width ,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          color: AppColors.primaryColor,
                        ),
                        child: Center(
                            child: AssetWidgets.loadingWidget(AppColors.white)),
                      );
                    }

                  else {
                    return const SizedBox();
                  }
                },
                listener: (context,state){
                  if(state is UserErrorEvent)
                    {
                      GeneralFunctions.showSnack(context, 'حدث خطأ يرجى المحاولة مرة أخرى.');
                    }

                  if(state is UserDoneEvent)
                    {
                      GeneralFunctions.showSnack(context, 'تم بنجاح.');

                    }
                }),

          ],
        ),
      ),
    );
  }
}

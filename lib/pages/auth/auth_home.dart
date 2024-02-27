import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/colors.dart';
import '../../controller/UserController.dart';
import '../../widget/AssetsWidget.dart';
import '../home/home.dart';
import '../pages/terms.dart';
import 'auth_otp.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({Key? key}) : super(key: key);

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {

  final _formKey = GlobalKey<FormState>();

  //Input controllers
  final TextEditingController _phoneController = TextEditingController();

  bool loading = false;

  UserController userController = UserController();

  checkNumber() async {

    setState(() {
      loading = true;
    });

    String phone = _phoneController.text.substring(2);


    var result = await userController.checkPhoneNumber(phone);

    if(result['success'] == 'false')
    {
      if(context.mounted)
      {
        setState(() {
          loading = false;
        });
        AssetWidgets.AlertDia(context,'فشل العملية','حدث خطأ، يرجى المحاولة مرة أخرى');

      }

      return;
    }else{
      if (!mounted) return;
      Navigator.pushReplacement(context,MaterialPageRoute(
          builder: (context) => AuthOTP(
            phone: phone,
            isNew: result['is_new'],
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child:  Column(

            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height/3,
                child: Image.asset('assets/images/logo.png',
                  width: MediaQuery.of(context).size.width/2,
                ),
              ),
              Expanded(flex:1,child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.5),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

                  child:SingleChildScrollView(child:SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        children:[
                          const SizedBox(height: 5,),
                          SizedBox(width: MediaQuery.of(context).size.width/8,
                            child: const Divider(thickness: 5,color: Colors.black,),
                          ),

                          const SizedBox(height: 25,),
                          const Text('أهلاً بك',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                          const SizedBox(height: 10,),
                          const Text('للمتابعة أدخل رقم هاتفك',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),

                          const SizedBox(height: 25,),
                          const Text('أدخل رقم هاتفك بالشكل التالي: 05xxxxxxxx',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12),),
                          const SizedBox(height: 5,),
                          Center(child: SizedBox(
                            width: MediaQuery.of(context).size.width/1.2,
                            child: AssetWidgets.textFormWidgetPhoneNumber(_phoneController, '', Icon(Icons.phone,color: AppColors.primaryColor,),req: true,number: true),
                          ),),
                          const SizedBox(height: 10,),
                          RichText(
                              text:TextSpan(
                                  text:  'بتسجيل الدخول أنت توافق على ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.blackColor,
                                    fontFamily: 'Cairo'
                                  ),
                              children: [
                                TextSpan(
                                  text: 'الشروط والأحكام',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Terms()),
                                      );
                                    },
                                )
                              ])
                          ),


                          const SizedBox(height: 20,),
                          Center(child: SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: AssetWidgets.buttonWidget(context, 'متابعة', (){
                                if (_formKey.currentState!.validate()) {
                                  checkNumber();
                                }


                              },isLoading: loading)
                          ),),



                          const SizedBox(height: 30,),
                          Center(child: InkWell(
                            onTap: () async {
                              //save on local
                              final prefs = await SharedPreferences.getInstance();
                              prefs.setString('skip', '1');
                              if(context.mounted)
                              {
                                Navigator.pushReplacement<void, void>(context,MaterialPageRoute<void>(
                                  builder: (BuildContext context) => const Home(),
                                ));
                              }

                            },
                            child: Text('الدخول كزائر',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.secondaryColor),),
                          ),),




                        ]
                    ),
                  )))),
            ],
          )),

    );
  }
}

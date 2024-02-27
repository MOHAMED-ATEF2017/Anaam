
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/colors.dart';
import '../../controller/UserController.dart';
import '../../widget/AssetsWidget.dart';
import '../home/home.dart';
import 'auth_home.dart';

class AuthOTP extends StatefulWidget {
  final String phone;
  final bool isNew;
  const AuthOTP({Key? key,required this.phone, required this.isNew}) : super(key: key);

  @override
  State<AuthOTP> createState() => _AuthOTPState();
}

class _AuthOTPState extends State<AuthOTP> {

  final _formKey = GlobalKey<FormState>();

  //Input controllers
  final TextEditingController _nameController = TextEditingController();
  String? otp = "" ;

  bool loading = false;

  UserController userController = UserController();

  checkOtp() async {

    setState(() {
      loading = true;
    });
    var result = await userController.checkOpt(widget.phone,otp!,_nameController.text);

    if(result['success'] == 'false')
    {
      if(context.mounted)
      {
        setState(() {
          loading = false;
        });
        AssetWidgets.AlertDia(context,'فشل العملية',' تأكد من صحة رمز التحقق وحاول مرة أخرى');
      }

      return;
    }else{
      if (!mounted) return;
      Navigator.pushReplacement(context,MaterialPageRoute(
          builder: (context) => const Home()));
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

                          const SizedBox(height: 25,),
                          if(widget.isNew)
                            Column(
                              children: [
                                const Text('يرجى ادخال اسمك',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),
                                const SizedBox(height: 10,),
                                Center(child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.2,
                                  child: AssetWidgets.textFormWidget(_nameController, ' الاسم', Icon(FontAwesomeIcons.user,color: AppColors.primaryColor,),req: true),
                                ),),
                              ],
                            ),

                          const SizedBox(height: 25,),
                          const Text('للمتابعة أدخل الرمز الذي تم ارساله إلى الرقم ',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),
                          Text('+966-5${widget.phone}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),textDirection: TextDirection.ltr,),

                          InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context,MaterialPageRoute(
                                  builder: (context) => const AuthHome()));
                            },
                            child: const Text('تغيير الرقم',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.grey,decoration: TextDecoration.underline,),),

                          ),
                          const SizedBox(height: 20,),
                          Directionality(
                              textDirection: TextDirection.ltr,
                              child:OTPTextField(
                                      length: 4,
                                      width: MediaQuery.of(context).size.width/1.2,
                                      fieldWidth: 80,
                                      style: const TextStyle(
                                          fontSize: 17
                                      ),

                                      textFieldAlignment: MainAxisAlignment.spaceAround,
                                      fieldStyle: FieldStyle.box,
                                      onChanged: (val) {
                                        otp = val;
                                      },
                                      onCompleted: (pin) {
                                        otp = pin;
                                      },
                                    )),

                          const SizedBox(height: 20,),
                          Center(child: SizedBox(
                              width: MediaQuery.of(context).size.width/2,
                              child: AssetWidgets.buttonWidget(context, 'متابعة', (){
                                if (_formKey.currentState!.validate()) {
                                  checkOtp();
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

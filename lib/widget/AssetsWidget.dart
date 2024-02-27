import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../config/colors.dart';


class AssetWidgets {
  static Widget textFormWidget(
      TextEditingController controllerP, String hint, Icon icon,
      {bool number = false, bool req = false, bool pass = false, bool multiRows = false, Function()? changeFun}) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        child:TextFormField(
          validator: (value) {
            if (req) {
              if (value == null || value.isEmpty) {
                return 'مطلوب';
              }
            }
            return null;
          },
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
          ),
          obscureText: pass,
          minLines: multiRows?4:1,
          maxLines: multiRows?null:1,
          controller: controllerP,
          keyboardType: number ? TextInputType.number : TextInputType.text,

          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            isDense: true,
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            prefixIcon: icon,

          ),
          autofocus: false,
          onTap: () {
            if (controllerP.selection.base.offset ==
                controllerP.text.length - 1) {
              controllerP
                .selection =
                    TextSelection.collapsed(offset: controllerP.text.length);
            }
          },
          onChanged: (value) {
            print(value);
            changeFun!();
          },
        ));
  }


  static Widget textFormWidgetPhoneNumber(
      TextEditingController controllerP, String hint, Icon icon,
      {bool number = false, bool req = false, bool pass = false, bool multiRows = false}) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        child:TextFormField(
          validator: (value) {
            if (req) {
              if (value == null || value.isEmpty) {
                return 'مطلوب';
              }

              if(value.length != 10)
                {
                  return 'تأكد أن رقم الهاتف يتألف من 10 أرقام.';
                }

              if(value[0] != '0' || value[1] != '5')
              {
                return 'يجب أن يبدأ رقم الهاتف بـ 05.';
              }

            }
            return null;
          },
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
          ),
          obscureText: pass,
          minLines: multiRows?4:1,
          maxLines: multiRows?null:1,
          controller: controllerP,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          keyboardType: number ? TextInputType.number : TextInputType.text,

          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            isDense: true,
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            prefixIcon: icon,
            // suffixIcon:  Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(' 05 ',style: TextStyle(color: AppColors.primaryColor),textDirection: TextDirection.ltr,),
            //   ],
            // )



          ),
          autofocus: false,
          onTap: () {
            if (controllerP.selection.base.offset ==
                controllerP.text.length - 1) {
              controllerP
                  .selection =
                  TextSelection.collapsed(offset: controllerP.text.length);
            }
          },
        ));
  }

  static Widget buttonWidget(
      BuildContext context, String title, Function() onPressed,
      {bool isLoading = false,
        double paddingValue = 7,
        double heightValue = 50,
        double textSize = 20,
        Color colorValue = Colors.black}) {
    return InkWell(
      onTap: () async {
        onPressed();
      },
      child: Container(
          height: heightValue,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(paddingValue),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorValue == Colors.black
                ? AppColors.primaryColor
                : colorValue,
          ),
          child: isLoading
              ? loadingWidget(AppColors.white)
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: textSize,
                    color: AppColors.white,
                    fontWeight: FontWeight.normal,
                  ),
                )),
    );
  }

  static Widget buttonBorderWidget(
      BuildContext context, String title, Function() onPressed,
      {bool isLoading = false,
        double paddingValue = 7,
        double heightValue = 50,
        double textSize = 20,
        Color colorValue = Colors.black}) {
    return InkWell(
      onTap: () async {
        onPressed();
      },
      child: Container(
          height: heightValue,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(paddingValue),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: isLoading
              ? loadingWidget(AppColors.white)
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: textSize,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.normal,
                  ),
                )),
    );
  }

  static Widget socialBTN(
      BuildContext context, Icon sIcon, Color bg, Function() onPressed,
      {bool isLoading = false}) {
    return InkWell(
      onTap: () async {
        onPressed();
      },
      child: Container(
          height: 50,
          width: 60,
          padding: const EdgeInsets.all(0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            //borderRadius: BorderRadius.circular(10),
            color: bg,
          ),
          child: isLoading ? loadingWidget(AppColors.white) : sIcon),
    );
  }

  static Widget loadingWidget(Color color) {
    return SpinKitDoubleBounce(
      color: color,
      size: 30.0,

    );
  }

  static AlertDia(BuildContext context,String title,String content){

    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:  Text(title),
          content:  Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ));
  }

}

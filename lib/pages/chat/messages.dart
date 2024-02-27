
import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';
import 'chat_details.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'الرسائل',cart: true,),
      bottomNavigationBar: showBottomNavBar(context, 2),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(10),
            child: Card(
                shape: RoundedRectangleBorder(
                  side:
                  const BorderSide( width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    expands: true,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    // controller: search_nameController,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration:  InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(top: 5), // add padding to adjust text
                      isDense: true,
                      hintText: 'البحث',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    onFieldSubmitted: (String str) {

                    },
                  ),
                )),
            ),

            box(),
            box(),
            box(),


          ],
        ),
      ),
    );
  }

  box(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const ChatDetails()));
      },
        child: const Padding(padding: EdgeInsets.all(10),
          child: Row(
            children: [
              //image
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.jpeg'),
                  radius: 35,
                ),
              // name and time and message
              Expanded(child:Padding(
                padding: EdgeInsets.all(10),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('محمد خالد',style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('أهلا وسهلا بك من الشيف خالد',style: TextStyle(fontSize: 14)),
                ],
              )))

            ],
          ),
    ));
  }
}

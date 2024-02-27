import 'package:flutter/material.dart';

import '../../config/api_urls.dart';
import '../../config/colors.dart';
import '../../controller/ApiController.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  ApiController api = ApiController();
  String content = "";
  bool isLoading = true;

  getData() async {
    setState(() {
      isLoading = true;
    });

    var data = await api.getRequest(ApiUrls.aboutPage);
    content = data['about']['content'];

    setState((){});

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarWidget(title: 'عن التطبيق',cart: false,),
        bottomNavigationBar: showBottomNavBar(context, 2),
        floatingActionButton: buildFloatingActionBtn(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body:  isLoading
            ? AssetWidgets.loadingWidget(AppColors.primaryColor)
            : SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(padding: const EdgeInsets.all(10),
                          child: Text(content,textAlign: TextAlign.right,))),

                ]))
    );
  }
}

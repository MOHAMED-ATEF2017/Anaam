
import 'package:flutter/material.dart';

import '../../config/api_urls.dart';
import '../../config/colors.dart';
import '../../controller/ApiController.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';

class Terms extends StatefulWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  State<Terms> createState() => _PageState();
}

class _PageState extends State<Terms> {

  ApiController api = ApiController();
  String content = "";
  bool isLoading = true;

  getData() async {
    setState(() {
      isLoading = true;
    });

    var data = await api.getRequest(ApiUrls.termsPage);
    content = data['terms']['content'];

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
        appBar: AppBarWidget(title: 'الشروط والأحكام',cart: false,),
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

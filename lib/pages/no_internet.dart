
import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child:Text('تأكد من اتصالك بالإنترنت')),
    );
  }
}

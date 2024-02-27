
import 'package:en3am_app/widget/AssetsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bank_accounts/banks_bloc.dart';
import '../../config/colors.dart';
import '../../functions/general_function.dart';
import '../../models/banks.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';

class Banks extends StatefulWidget {
  const Banks({Key? key}) : super(key: key);

  @override
  State<Banks> createState() => _BanksState();
}

class _BanksState extends State<Banks> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<BanksBloc>(context).add(GetAccountsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'الحسابات البنكية',cart: false,),
      bottomNavigationBar: showBottomNavBar(context, 2),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocBuilder<BanksBloc, BanksState>(
        builder: (context, state) {
          if(state is LoadingAccountsState)
          {
              return AssetWidgets.loadingWidget(AppColors.primaryColor2);
          } else if(state is LoadedAccountsState)
          {
              return  Column(
                children: [
                  for(int i=0; i< state.data.length; i++)
                    accountBox(state.data[i]),
                ],
              );
          } else if(state is ErrorAccountsState)
          {
              return Center(child: Text(state.message),);
          }else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget accountBox(BanksModel bank)
  {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5,color: AppColors.gry1),
        borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('اسم البنك: ${bank.bankName}'))
            ],
          ),

          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: Text('اسم الحساب: ${bank.accountName}')),
              InkWell(
                onTap: (){
                  GeneralFunctions.copyText(context,bank.accountName);
                },
                child: const Icon(Icons.copy),
              ),

            ],
          ),

          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: Text('رقم الحساب: ${bank.accountNumber}')),
              InkWell(
                onTap: (){
                  GeneralFunctions.copyText(context,bank.accountNumber);
                },
                child: const Icon(Icons.copy),
              ),

            ],
          ),

          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: Text('رقم الأيبان: ${bank.iban}')),
              InkWell(
                onTap: (){
                  GeneralFunctions.copyText(context,bank.iban);
                },
                child: const Icon(Icons.copy),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

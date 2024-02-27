
import 'package:en3am_app/widget/AssetsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../config/colors.dart';
import '../../functions/general_function.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';

class Social extends StatefulWidget {
  const Social({Key? key}) : super(key: key);

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SettingsBloc>(context).add(GetSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'حسابات التواصل الاجتماعي',cart: false,),
      bottomNavigationBar: showBottomNavBar(context, 2),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if(state is LoadingState)
          {
              return AssetWidgets.loadingWidget(AppColors.primaryColor2);
          } else if(state is LoadedState)
          {
              return  Center(child:
                Column(
                  children: [
                    const SizedBox(height: 50,),
                    const Text('تابعنا على وسائل التواصل الإجتماعي',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 50,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            GeneralFunctions.openUrl(state.data['fb']['content']);
                          },
                          child: Icon(FontAwesomeIcons.facebook,size: 45,color: AppColors.facebook,),
                        ),
                        const SizedBox(width: 15,),

                        InkWell(
                          onTap: (){
                            GeneralFunctions.openUrl('whatsapp://send?phone=966${state.data['whatsapp']['content']}');

                          },
                          child:  Icon(FontAwesomeIcons.whatsapp,size: 45,color: AppColors.whatsapp,),
                        ),
                        const SizedBox(width: 15,),

                        InkWell(
                          onTap: (){
                            GeneralFunctions.openUrl(state.data['instagram']['content']);

                          },
                          child:  Icon(FontAwesomeIcons.instagram,size: 45,color: AppColors.instagram,),
                        ),
                        const SizedBox(width: 15,),

                        InkWell(
                          onTap: (){
                            GeneralFunctions.openUrl(state.data['twitter']['content']);

                          },
                          child: Icon(FontAwesomeIcons.snapchat,size: 45,color: AppColors.blackColor,),
                        ),
                        const SizedBox(width: 10,),
                      ],
                    )

                  ],
                )
                ,);
          } else if(state is ErrorState)
          {
              return Center(child: Text(state.message),);
          }else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

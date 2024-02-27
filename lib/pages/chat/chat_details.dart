import 'dart:convert';

import 'package:en3am_app/bloc/chat/chat_bloc.dart';
import 'package:en3am_app/functions/general_function.dart';
import 'package:en3am_app/widget/AssetsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/colors.dart';
import '../../controller/ChatController.dart';
import '../../widget/appbar.dart';
import '../../models/chat_message.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({Key? key}) : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final TextEditingController _messageController = TextEditingController();
  bool sendLoading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ChatBloc>(context).add(SetToMessageLoading());
    BlocProvider.of<ChatBloc>(context).add(GetUserMessages());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarWidget(
          title: 'الرسائل',
          cart: true,
        ),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            child: Stack(
                children: [
                  BlocConsumer<ChatBloc, ChatState>(listener: (context, state) async {
                      if (state is LoadedUserMessages) {
                        await Future.delayed(const Duration(seconds: 1));
                        scrollToBottom();
                      }
                    }, builder: (context, state) {
                      if (state is LoadingUserMessages) {
                        return AssetWidgets.loadingWidget(AppColors.primaryColor);
                      }

                      if (state is LoadedUserMessages) {
                        if(state.data.isNotEmpty)
                        {
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            controller: _scrollController,
                            itemCount: state.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return messageBox(state.data[index]);
                            },
                          );

                        }else{
                          return const Center(child: Text('أهلاً بك، أرسل أي اسفسار وسنجيبك في أسرع وقت.'),);
                        }

                      }

                      if (state is GetError) {
                        return Center(child: InkWell(
                            onTap: () {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(SetToMessageLoading());
                              BlocProvider.of<ChatBloc>(context)
                                  .add(GetUserMessages());
                            },
                            child: const Text(
                              'حدث خطأ لم نتمكن من جلب الرسائل، انقر للمحاولة مرةأخرى',
                            )),);
                      }

                      return const SizedBox();

                    }),

              Positioned(bottom: 0, child: chatInput()),
            ])));
  }

  Widget chatInput() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                hintText: 'اكتب هنا',
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 2,
                  minHeight: 2,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children: <Widget>[
                        InkWell(
                          onTap: () => sendMessage(),
                          child: sendLoading? 
                              AssetWidgets.loadingWidget(AppColors.primaryColor)
                          :Icon(
                            Icons.send,
                            size: 26,
                            color: AppColors.primaryColor,
                          ),
                        ),

                      ]),
                )),
            maxLines: 5,
            minLines: 1,
            autofocus: false,
            onTap: () {
              if (_messageController.selection.base.offset ==
                  _messageController.text.length - 1) {
                _messageController.selection = TextSelection.collapsed(
                    offset: _messageController.text.length);
              }
            },
          ),
        ));
  }

  Widget messageBox(ChatMessage message) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment:
            (message.sender == 1 ? Alignment.topLeft : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (message.sender == 1
                ? Colors.grey.shade200
                : AppColors.primaryColor),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            message.message,
            style: TextStyle(
                fontSize: 15,
                color: message.sender == 1 ? Colors.black : AppColors.white),
          ),
        ),
      ),
    );
  }

  sendMessage() async {


    if(_messageController.text.isNotEmpty)
      {
        try{
          setState(() {
            sendLoading = true;
          });

          String response = await ChatController().sendMessage(_messageController.text);

          if(response == "error")
          {
            setState(() {
              sendLoading = false;
            });
            if(context.mounted)
              {
                GeneralFunctions.showSnack(context, 'حدث خطأ يرجى المحاولة مرة أخرى');
              }
          }

          var data = json.decode(response);

          if(data['success'] == false)
          {
            setState(() {
              sendLoading = false;
            });
            if(context.mounted)
            {
              GeneralFunctions.showSnack(context, 'حدث خطأ يرجى المحاولة مرة أخرى');
            }

          }
          if(data['success'] == true)
          {

            if(context.mounted)
              {
                BlocProvider.of<ChatBloc>(context).add(SetToMessageLoading());
                BlocProvider.of<ChatBloc>(context).add(GetUserMessages());
                setState(() {
                  _messageController.text = "";
                  sendLoading = false;
                });
              }

          }

        }catch(e){
          setState(() {
            sendLoading = false;
          });
          if(context.mounted)
          {
            GeneralFunctions.showSnack(context, 'حدث خطأ يرجى المحاولة مرة أخرى');
          }
        }
      }
  }

  scrollToBottom (){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}

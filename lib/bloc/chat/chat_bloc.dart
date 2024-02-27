import 'dart:async';
import 'dart:convert';

import 'package:en3am_app/controller/ChatController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if(event is GetUserMessages)
        {

          try{
            String response = await ChatController().getUserMessages();

            Map<String, dynamic> res = json.decode(response);

            List<ChatMessage> data = List<ChatMessage>.from(
                res['data'].map((x) => ChatMessage.fromJson(x)));

            emit(LoadedUserMessages(data: data));

          }catch(e){

            emit(GetError());
          }
        }

      if(event is SetToMessageLoading)
        {
          emit(LoadingUserMessages());
        }
    });
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../controller/ApiController.dart';

part 'minced_event.dart';
part 'minced_state.dart';

class MincedBloc extends Bloc<MincedEvent, MincedState> {
  MincedBloc() : super(MincedLoadingState()) {
    on<MincedEvent>((event, emit) async {
      if(event is GetMincedEvent)
        {
          try{
            emit(MincedLoadingState());
            String response = await ApiController().getMinced();



            if(response == "error")
              {
                emit(MincedErrorState());
              }

            Map<String, dynamic> res = json.decode(response);
            emit(MincedLoadedState(data: int.parse(res['price'].toString())));
          }catch (e)
          {
            emit(MincedErrorState());
          }

        }
    });
  }
}

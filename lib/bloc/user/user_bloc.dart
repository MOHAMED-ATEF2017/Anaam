import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/UserController.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if(event is UpdateUserDataEvent)
        {
          emit(UserLoadingState());

          try{

            String res = await UserController().updateUserData(event.name, event.address, event.cityId);


            if(res == "error")
            {
              emit(UserErrorEvent());
            }

            var data = json.decode(res);




            if(data['success'] == 'true')
            {
              emit( UserDoneEvent());

              final prefs = await SharedPreferences.getInstance();

              const key4 = 'name';
              final value4 = event.name;
              prefs.setString(key4, value4);

              const key5 = 'address';
              final value5 = event.address;
              prefs.setString(key5, value5);

              const key6 = 'city_id';
              final value6 = event.cityId;
              prefs.setInt(key6, int.parse(value6) );


            }else{
              emit(UserErrorEvent());
            }

          }catch(e){
            emit(UserErrorEvent());
          }
        }

      if(event is SetToInitState)
        {
          emit(UserInitial());
        }
    });
  }
}

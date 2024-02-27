
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../controller/ApiController.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(LoadingState()) {
    on<SettingsEvent>((event, emit) async {
      if(event is GetSettings)
        {
          emit(LoadingState());

          //call api
          try{
            final Map<String, dynamic> data = await ApiController().getSettings();
            emit(LoadedState(data));
          }catch(e)
          {
            emit(const ErrorState('حدث خطأ'));
          }

        }
    });
  }
}

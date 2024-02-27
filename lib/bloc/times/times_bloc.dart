import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../controller/ApiController.dart';
import '../../models/times.dart';

part 'times_event.dart';
part 'times_state.dart';

class TimesBloc extends Bloc<TimesEvent, TimesState> {
  TimesBloc() : super(LoadingTimesState()) {
    on<TimesEvent>((event, emit) async {

      if(event is GetTimesEvent)
      {
        emit(LoadingTimesState());

        //call api
        try{
          final List<TimesModel> data = await ApiController().getTimes();
          emit(LoadedTimesState(data));
        }catch(e)
        {
          emit(const ErrorTimesState('فشل تحميل المدن، يرجى المحاولة مرة أخرى'));
        }

      }

    });
  }
}

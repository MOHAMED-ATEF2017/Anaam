import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:en3am_app/models/cities.dart';
import 'package:equatable/equatable.dart';

import '../../controller/ApiController.dart';

part 'cities_event.dart';
part 'cities_state.dart';

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  CitiesBloc() : super(LoadingCitiesState()) {
    on<CitiesEvent>((event, emit) async {

      if(event is GetCitiesEvent)
      {
        emit(LoadingCitiesState());

        //call api
        try{
          final List<CitiesModel> data = await ApiController().getCities();
          emit(LoadedCitiesState(data));
        }catch(e)
        {
          emit(const ErrorCitiesState('فشل تحميل المدن، يرجى المحاولة مرة أخرى'));
        }

      }
    });
  }
}

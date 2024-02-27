import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../controller/ApiController.dart';
import '../../models/packaging.dart';

part 'packaging_event.dart';
part 'packaging_state.dart';

class PackagingBloc extends Bloc<PackagingEvent, PackagingState> {
  PackagingBloc() : super(LoadingPackagingState()) {
    on<PackagingEvent>((event, emit) async {
      if(event is GetPackaging)
      {
        emit(LoadingPackagingState());

        //call api
        try{
          final List<PackagingModel> data = await ApiController().getPackaging();
          emit(LoadedPackagingState(data));
        }catch(e)
        {
          emit(const ErrorPackagingState('لم نتمكن من تحميل طرق التغليف، يرجى المحاولة مرة أخرى'));
        }

      }
    });
  }
}

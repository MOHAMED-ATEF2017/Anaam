import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../controller/ApiController.dart';
import '../../models/cutting.dart';

part 'cutting_event.dart';
part 'cutting_state.dart';

class CuttingBloc extends Bloc<CuttingEvent, CuttingState> {
  CuttingBloc() : super(LoadingState()) {
    on<CuttingEvent>((event, emit) async {
      if(event is GetCutting)
      {
        emit(LoadingState());

        //call api
        try{
          final List<CuttingModel> data = await ApiController().getCutting();
          emit(LoadedState(data));
        }catch(e)
        {
          emit(const ErrorState('لم نتمكن من تحميل طرق التقطيع، يرجى المحاولة مرة أخرى'));
        }

      }
    });
  }
}

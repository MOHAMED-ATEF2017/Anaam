import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../controller/ApiController.dart';
import '../../models/banks.dart';

part 'banks_event.dart';
part 'banks_state.dart';

class BanksBloc extends Bloc<BanksEvent, BanksState> {
  BanksBloc() : super(LoadingAccountsState()) {
    on<BanksEvent>((event, emit) async {

      if(event is GetAccountsEvent)
        {
          emit(LoadingAccountsState());

          //call api
          // try{
            final List<BanksModel> data = await ApiController().getBankAccounts();
            emit(LoadedAccountsState(data));
          // }catch(e)
          // {
          //   emit(const ErrorAccountsState('فشل تحميل الحسابات البنكية، يرجى المحاولة مرة أخرى'));
          //
          // }
        }
    });
  }
}

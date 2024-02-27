import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_check_event.dart';
part 'internet_check_state.dart';

class InternetCheckBloc extends Bloc<InternetCheckEvent, InternetCheckState> {
  StreamSubscription? subscription;
  InternetCheckBloc() : super(InternetCheckInitial()) {
    on<InternetCheckEvent>((event, emit) {
      if (event is ConnectedEvent) {
        emit(ConnectedState());
      }
      else if (event is NotConnectedEvent) {
        emit(NotConnectedState());
      }
    });

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile)
      {
        add(ConnectedEvent());
      }else{
        add(NotConnectedEvent());
      }
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close
    subscription!.cancel();
    return super.close();
  }
}

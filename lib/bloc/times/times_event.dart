part of 'times_bloc.dart';

abstract class TimesEvent extends Equatable {
  const TimesEvent();

  @override
  List<Object?> get props => [];
}

class GetTimesEvent extends TimesEvent {}
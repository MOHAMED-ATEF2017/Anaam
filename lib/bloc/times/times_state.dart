part of 'times_bloc.dart';

abstract class TimesState extends Equatable {
  const TimesState();

  @override
  List<Object> get props => [];
}

class LoadingTimesState extends TimesState {}
class LoadedTimesState extends TimesState {
  final List<TimesModel> data;

  const LoadedTimesState(this.data);

  @override
  List<Object> get props => [data];

}
class ErrorTimesState extends TimesState {
  final String message;

  const ErrorTimesState(this.message);

  @override
  List<Object> get props => [message];
}

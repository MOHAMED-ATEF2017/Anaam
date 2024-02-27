part of 'cities_bloc.dart';

abstract class CitiesState extends Equatable {
  const CitiesState();

  @override
  List<Object> get props => [];
}

class LoadingCitiesState extends CitiesState {}
class LoadedCitiesState extends CitiesState {
  final List<CitiesModel> data;

  const LoadedCitiesState(this.data);

  @override
  List<Object> get props => [data];

}
class ErrorCitiesState extends CitiesState {
  final String message;

  const ErrorCitiesState(this.message);

  @override
  List<Object> get props => [message];
}

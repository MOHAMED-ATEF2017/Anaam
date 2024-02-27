part of 'cities_bloc.dart';

abstract class CitiesEvent extends Equatable {
  const CitiesEvent();

  @override
  List<Object?> get props => [];
}

class GetCitiesEvent extends CitiesEvent {}

part of 'cutting_bloc.dart';

abstract class CuttingEvent extends Equatable {
  const CuttingEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetCutting extends CuttingEvent {}

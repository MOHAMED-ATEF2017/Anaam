part of 'cutting_bloc.dart';

abstract class CuttingState extends Equatable {
  const CuttingState();

  @override
  List<Object> get props => [];
}

class LoadingState extends CuttingState {}

class LoadedState extends CuttingState {
  final List<CuttingModel> data;

  const LoadedState(this.data);

  @override
  List<Object> get props => [data];

}

class ErrorState extends CuttingState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object> get props => [message];

}

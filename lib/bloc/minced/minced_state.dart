part of 'minced_bloc.dart';

abstract class MincedState extends Equatable {
  const MincedState();

  @override
  List<Object> get props => [];
}

class MincedLoadingState extends MincedState {}
class MincedLoadedState extends MincedState {
  final int data;

  const MincedLoadedState({required this.data});

  @override
  List<Object> get props => [data];
}
class MincedErrorState extends MincedState {}

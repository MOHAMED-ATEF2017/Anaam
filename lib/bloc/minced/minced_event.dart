part of 'minced_bloc.dart';

abstract class MincedEvent extends Equatable {
  const MincedEvent();

  @override
  List<Object?> get props => [];
}

class GetMincedEvent extends MincedEvent{}

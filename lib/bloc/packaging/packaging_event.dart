part of 'packaging_bloc.dart';

abstract class PackagingEvent extends Equatable {
  const PackagingEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetPackaging extends PackagingEvent {}
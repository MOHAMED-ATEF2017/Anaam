part of 'packaging_bloc.dart';

abstract class PackagingState extends Equatable {
  const PackagingState();

  List<Object> get props => [];
}

class LoadingPackagingState extends PackagingState {}

class LoadedPackagingState extends PackagingState {
  final List<PackagingModel> data;

  const LoadedPackagingState(this.data);

  @override
  List<Object> get props => [data];

}

class ErrorPackagingState extends PackagingState {
  final String message;

  const ErrorPackagingState(this.message);

  @override
  List<Object> get props => [message];

}

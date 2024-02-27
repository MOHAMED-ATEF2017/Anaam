part of 'banks_bloc.dart';

abstract class BanksState extends Equatable {
  const BanksState();

  List<Object> get props => [];
}

class LoadingAccountsState extends BanksState {}
class LoadedAccountsState extends BanksState {
  final List<BanksModel> data;

  const LoadedAccountsState(this.data);

  @override
  List<Object> get props => [data];

}
class ErrorAccountsState extends BanksState {
  final String message;

  const ErrorAccountsState(this.message);

  @override
  List<Object> get props => [message];
}

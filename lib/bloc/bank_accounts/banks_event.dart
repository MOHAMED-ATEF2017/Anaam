part of 'banks_bloc.dart';

abstract class BanksEvent extends Equatable {
  const BanksEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAccountsEvent extends BanksEvent{}

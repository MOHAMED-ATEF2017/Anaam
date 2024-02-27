part of 'internet_check_bloc.dart';

@immutable
abstract class InternetCheckState {}

class InternetCheckInitial extends InternetCheckState {}

class ConnectedState extends InternetCheckState {}

class NotConnectedState extends InternetCheckState {}

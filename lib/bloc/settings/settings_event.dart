part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetSettings extends SettingsEvent {}

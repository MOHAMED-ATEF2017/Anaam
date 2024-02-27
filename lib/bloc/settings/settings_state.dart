part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends SettingsState {}

class LoadedState extends SettingsState {
  final Map<String, dynamic> data;

  const LoadedState(this.data);

  @override
  List<Object> get props => [data];

}

class ErrorState extends SettingsState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object> get props => [message];

}


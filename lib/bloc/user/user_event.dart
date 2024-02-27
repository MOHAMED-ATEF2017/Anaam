part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UpdateUserDataEvent extends UserEvent {
  final String cityId;
  final String name;
  final String address;

  const UpdateUserDataEvent({required this.cityId, required this.name, required this.address});

  @override
  List<Object?> get props => [cityId,name,address];

}

class SetToInitState extends UserEvent{}

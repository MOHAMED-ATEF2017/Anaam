part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetUserMessages extends ChatEvent {}

class SendMessages extends ChatEvent {
  final String message;

  const SendMessages({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class SetToMessageLoading extends ChatEvent{}

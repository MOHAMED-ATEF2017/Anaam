part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}


class LoadingUserMessages extends ChatState{}
class LoadingSend extends ChatState{}

class LoadedUserMessages extends ChatState{
  final List<ChatMessage> data;

  const LoadedUserMessages({required this.data});

  @override
  List<Object> get props => [data];
}

class SendError extends ChatState{}
class GetError extends ChatState{}



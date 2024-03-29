import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_wave/chat/data/repository/message_repository.dart';
import 'package:chat_wave/core/domain/model/message.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc({
    required this.channelId,
  }) : super(const MessagesList([])) {
    on<LoadedMessages>((event, emit) {
      emit(MessagesList(event.messages));
    });

    _subscription = _messageRepository.watchChannelMessages(channelId).listen(
      (event) {
        add(LoadedMessages(event));
      },
    );
  }
  late final StreamSubscription _subscription;

  final int channelId;
  final _messageRepository = locator<MessageRepository>();

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

import 'package:flutter/material.dart';

import 'message.dart';

@immutable
class DmMessage extends Message {
  const DmMessage({
    required String id,
    required String? text,
    required int senderId,
    required String formattedDate,
    required bool isOwnMessage,
    required this.receiverId,
    required this.seen,
  }) : super(
          id: id,
          senderId: senderId,
          formattedDate: formattedDate,
          text: text,
          isOwnMessage: isOwnMessage,
        );

  final int receiverId;
  final bool seen;

  @override
  List<Object?> get props => super.props
    ..addAll([
      receiverId,
      seen,
    ]);
}

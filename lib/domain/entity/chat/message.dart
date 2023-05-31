import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:minder/data/model/chat/message_model.dart';

class Message {
  late String? id;
  late String groupId;
  late String senderId;
  late int messageType;
  late String content;
  late DateTime createAt;
  late bool isSend;
  late bool isDisplayAvatar;
  late bool isDisplayTime;
  late String? avatar;
  late String? name;
  late String? userId;

  Message({
    this.id,
    required this.groupId,
    required this.senderId,
    required this.messageType,
    required this.content,
    required this.createAt,
    required this.isSend,
    required this.isDisplayAvatar,
    required this.isDisplayTime,
    this.avatar,
    this.userId,
    this.name,
  });

  toDisplayTime() {
    DateFormat dateFormat = DateFormat("HH:mm");
    return dateFormat.format(createAt.toLocal());
  }

  toDisplayTimeLine() {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    var dow = createAt.weekday == 1 ? "CN" : "T${createAt.weekday}";
    return "$dow , ${dateFormat.format(createAt.toLocal())}";
  }

  Message.fromModel(MessageModel messageModel) {
    id = messageModel.id ?? "";
    groupId = messageModel.groupId ?? "";
    senderId = messageModel.senderId ?? "";
    messageType = messageModel.messageType ?? 0;
    createAt = DateTime.parse(messageModel.createAt ?? "");
    content = messageModel.content ?? "";
    isSend = messageModel.isSend ?? false;
    isDisplayAvatar = messageModel.isDisplayAvatar ?? false;
    isDisplayTime = messageModel.isDisplayTime ?? false;
    avatar = messageModel.avatar ?? "";
    name = messageModel.name ?? "";
    userId = messageModel.userId ?? "";
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      groupId: map['groupId'],
      senderId: map['senderId'],
      messageType: map['messageType'],
      content: map['content'],
      createAt: map['createAt'],
      isSend: map['isSend'],
      isDisplayAvatar: map['isDisplayAvatar'],
      isDisplayTime: map['isDisplayTime'],
      avatar: map['avatar'],
      name: map['name'],
      userId: map['userId'],
    );
  }

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}

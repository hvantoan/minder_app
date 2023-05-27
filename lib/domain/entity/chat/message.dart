import 'package:intl/intl.dart';
import 'package:minder/data/model/chat/message_model.dart';

class Message {
  late String id;
  late String groupId;
  late String senderId;
  late int messageType;
  late String content;
  late DateTime createAt;
  late bool isSend;
  late bool isDisplayAvatar;
  late bool isDisplayTime;
  late String? avatar;
  late String name;
  late String userId;

  Message({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.messageType,
    required this.content,
    required this.createAt,
    required this.isSend,
    this.avatar,
    required this.userId,
    required this.name,
    required this.isDisplayAvatar,
    required this.isDisplayTime,
  });

  toDisplayTime() {
    DateFormat dateFormat = DateFormat("HH:mm");
    return dateFormat.format(createAt);
  }

  toDisplayTimeLine() {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    var dow = createAt.weekday == 1 ? "CN" : "T${createAt.weekday}";
    return "$dow , ${dateFormat.format(createAt)}";
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
}

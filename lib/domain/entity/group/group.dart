// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:minder/data/model/group/group_model.dart';

class Group {
  String id;
  String title;
  String chanelId;
  String lastMessage;
  DateTime createAt;
  int type;
  String displayType;
  bool online;
  String? avatar;
  List<int>? data;
  Group(
      {required this.id,
      required this.title,
      required this.chanelId,
      required this.lastMessage,
      required this.createAt,
      required this.type,
      required this.displayType,
      required this.online,
      this.avatar,
      this.data});

  factory Group.fromModel(GroupModel model) {
    return Group(
      id: model.id ?? "",
      title: model.title ?? "",
      chanelId: model.chanelId ?? "",
      lastMessage: model.lastMessage ?? "",
      createAt: model.createAt ?? DateTime.now(),
      type: model.type ?? 0,
      displayType: model.displayType ?? "Team",
      online: model.online ?? false,
      avatar: model.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'chanelId': chanelId,
      'lastMessage': lastMessage,
      'createAt': createAt.millisecondsSinceEpoch,
      'type': type,
      'displayType': displayType,
      'online': online,
      'avatar': avatar,
      'data': data
    };
  }
}

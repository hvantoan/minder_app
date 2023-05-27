import 'dart:convert';

class GroupModel {
  String? id;
  String? title;
  String? chanelId;
  String? lastMessage;
  DateTime? createAt;
  int? type;
  String? displayType;
  bool? online;
  String? avatar;
  GroupModel(
      {this.id,
      this.title,
      this.chanelId,
      this.lastMessage,
      this.createAt,
      this.type,
      this.displayType,
      this.online,
      this.avatar});

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      chanelId: map['chanelId'] != null ? map['chanelId'] as String : null,
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      createAt: DateTime.parse(map['createAt']),
      type: map['type'] != null ? map['type'] as int : null,
      displayType:
          map['displayType'] != null ? map['displayType'] as String : null,
      online: map['online'] != null ? map['online'] as bool : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
    );
  }

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

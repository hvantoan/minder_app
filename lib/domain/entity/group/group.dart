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

  Group({
    required this.id,
    required this.title,
    required this.chanelId,
    required this.lastMessage,
    required this.createAt,
    required this.type,
    required this.displayType,
    required this.online,
    this.avatar,
  });

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
}

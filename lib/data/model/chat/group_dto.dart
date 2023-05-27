class GroupDto {
  String? id;
  String? title;
  String? channelId;
  String? teamId;
  String? lastMessage;
  String? createAt;
  bool? online;

  GroupDto(
      {this.id,
      this.title,
      this.channelId,
      this.teamId,
      this.lastMessage,
      this.createAt,
      this.online});

  GroupDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    channelId = json['channelId'];
    teamId = json['teamId'];
    lastMessage = json['lastMessage'];
    createAt = json['createAt'];
    online = json['online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['channelId'] = channelId;
    data['teamId'] = teamId;
    data['lastMessage'] = lastMessage;
    data['createAt'] = createAt;
    data['online'] = online;
    return data;
  }
}

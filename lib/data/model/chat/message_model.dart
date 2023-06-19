class MessageModel {
  String? id;
  String? groupId;
  String? senderId;
  int? messageType;
  String? content;
  String? createAt;
  bool? isSend;
  bool? isDisplayAvatar;
  bool? isDisplayTime;
  String? avatar;
  String? name;
  String? userId;
  String? imagePath;

  MessageModel({
    this.id,
    this.groupId,
    this.senderId,
    this.messageType,
    this.content,
    this.createAt,
    this.isSend,
    this.avatar,
    this.name,
    this.userId,
    this.isDisplayAvatar,
    this.isDisplayTime,
    this.imagePath,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['groupId'];
    senderId = json['senderId'];
    messageType = json['messageType'];
    content = json['content'];
    createAt = json['createAt'];
    isSend = json['isSend'];
    isDisplayAvatar = json['isDisplayAvatar'];
    isDisplayTime = json['isDisplayTime'];
    name = json['user']?['name'];
    userId = json['user']?['id'];
    avatar = json['user']?['avatar'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['groupId'] = groupId;
    data['senderId'] = senderId;
    data['messageType'] = messageType;
    data['content'] = content;
    data['createAt'] = createAt;
    return data;
  }
}

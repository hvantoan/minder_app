import 'dart:convert';

class SendMessageRequest {
  final String groupId;
  final String content;
  SendMessageRequest({
    required this.groupId,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId,
      'content': content,
    };
  }

  String toJson() => json.encode(toMap());
}

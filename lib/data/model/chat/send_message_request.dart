import 'dart:convert';
import 'dart:typed_data';

class SendMessageRequest {
  final String groupId;
  final String content;
  final Uint8List? file;
  SendMessageRequest({required this.groupId, required this.content, this.file});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId,
      'content': content,
      'file': file
    };
  }

  String toJson() => json.encode(toMap());
}

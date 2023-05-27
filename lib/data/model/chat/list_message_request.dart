// ignore_for_file: public_member_api_docs, sort_constructors_first
class ListMessageRequest {
  int pageIndex;
  int pageSize;
  String? searchText;
  bool isCount;
  String groupId;
  ListMessageRequest({
    this.pageIndex = 0,
    this.pageSize = 20,
    this.searchText,
    this.isCount = false,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'searchText': searchText,
      'isCount': isCount,
      'groupId': groupId,
    };
  }
}

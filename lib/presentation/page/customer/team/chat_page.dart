import 'package:flutter/material.dart';
import 'package:minder/domain/entity/group/group.dart';
import 'package:minder/presentation/page/customer/home/conversation_page.dart';

class TeamChatPage extends StatefulWidget {
  const TeamChatPage({
    super.key,
    required this.group,
    required this.height,
    required this.appBarDisplay,
  });

  final double height;
  final Group group;
  final bool appBarDisplay;

  @override
  State<TeamChatPage> createState() => _TeamChatPageState();
}

class _TeamChatPageState extends State<TeamChatPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ConversationPage(
        appBarDisplay: false,
        group: widget.group,
      ),
    );
  }
}

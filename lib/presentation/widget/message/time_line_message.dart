import 'package:flutter/material.dart';
import 'package:minder/domain/entity/chat/message.dart';
import 'package:minder/util/style/base_style.dart';

class TimeLineMessage extends StatelessWidget {
  const TimeLineMessage({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message.toDisplayTimeLine(),
              style: BaseTextStyle.body2(color: BaseColor.grey500),
            ),
          ),
          const Expanded(child: Divider(height: 1)),
        ],
      ),
    );
  }
}

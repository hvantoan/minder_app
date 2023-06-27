import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:minder/domain/entity/chat/message.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/util/style/base_size.dart';
import 'package:minder/util/style/base_style.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({super.key, required this.message, this.file});
  final Message message;
  final Uint8List? file;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: message.isSend ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: message.isDisplayAvatar ? 16 : 4,
        left: message.isSend ? padding : 0,
        right: message.isSend ? 0 : padding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSend)
            message.isDisplayAvatar
                ? Padding(
                    padding: const EdgeInsets.only(right: 12, top: 23),
                    child: AvatarWidget.base(
                        imagePath: message.avatar, name: "ND", size: 24),
                  )
                : Container(width: 36),
          SizedBox(
            width: size.width - 32 - padding - (message.isSend ? 0 : 36),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: message.isSend
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (message.isDisplayAvatar && !message.isSend)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(message.name ?? "",
                        style: BaseTextStyle.body2(color: BaseColor.blue500)),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color:
                        message.isSend ? BaseColor.green100 : BaseColor.grey100,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(message.isSend ? 2 : 8),
                      topLeft: Radius.circular(message.isSend ? 8 : 2),
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: message.isSend
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      _buildImage(file, context),
                      if (message.content.isNotEmpty)
                        Text(message.content, style: BaseTextStyle.body1()),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                if (message.isDisplayTime)
                  Text(
                    message.toDisplayTime(),
                    style: BaseTextStyle.caption(color: BaseColor.grey500),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildImage(Uint8List? data, BuildContext context) {
    if (data != null) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: BaseColor.grey100)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            data,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.replay_outlined,
                  color: Colors.red,
                  size: 32,
                ),
              );
            },
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: BaseColor.grey100)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          message.imagePath!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
                child: Icon(
              Icons.replay_outlined,
              color: Colors.red,
              size: 32,
            ));
          },
        ),
      ),
    );
  }
}

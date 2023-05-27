import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/data/model/chat/send_message_request.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/message/message_cubit.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_shadow_style.dart';
import 'package:minder/util/style/base_text_style.dart';

const double _emojiHeight = 312;

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.groupId, this.onFocus});

  final String groupId;
  final VoidCallback? onFocus;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _emojiShowing = false;
  bool _hasSend = false;
  final TextEditingController _textMessage = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _emojiShowing = false;
        if (widget.onFocus != null) widget.onFocus;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.only(
          bottom: bottom +
              (_focusNode.hasPrimaryFocus
                  ? 0
                  : MediaQuery.of(context).padding.bottom)),
      child: Wrap(children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BaseShadowStyle.bottomNavigation],
          ),
          width: size.width,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _textMessage,
                    textAlignVertical: TextAlignVertical.center,
                    style: BaseTextStyle.body2(),
                    focusNode: _focusNode,
                    onChanged: (value) {
                      if (value.isEmpty && _hasSend) {
                        _hasSend = false;
                        setState(() {});
                      } else if (value.isNotEmpty && !_hasSend) {
                        _hasSend = true;
                        setState(() {});
                      }
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: BaseColor.grey100,
                      filled: true,
                      hintText: S.current.txt_write_something,
                      hintStyle: BaseTextStyle.body2(),
                      contentPadding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 16, right: 16),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _focusNode.unfocus();
                          Future.delayed(const Duration(microseconds: 200))
                              .then((value) => setState(
                                  () => _emojiShowing = !_emojiShowing));
                        },
                        icon: BaseIcon.base(IconPath.emojiLine,
                            color: BaseColor.grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(
                            color: BaseColor.grey100, width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(
                            color: BaseColor.grey100, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(
                            color: BaseColor.grey100, width: 1.0),
                      ),
                    ),
                    onEditingComplete: () => _onEditingComplete(),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_hasSend) {
                      _send(
                        SendMessageRequest(
                          groupId: widget.groupId,
                          content: _textMessage.text,
                        ),
                      );
                      _textMessage.clear();
                      _hasSend = false;
                      setState(() {});
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: !_hasSend ? BaseColor.grey100 : null,
                      gradient: _hasSend
                          ? const LinearGradient(
                              colors: [BaseColor.green300, BaseColor.green500])
                          : null,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        IconPath.sendLine,
                        color: !_hasSend ? BaseColor.grey300 : null,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Offstage(
              offstage: !_emojiShowing,
              child: SizedBox(
                height: _emojiHeight,
                child: EmojiPicker(
                  textEditingController: _textMessage,
                  onEmojiSelected: (category, emoji) {
                    if (_textMessage.text.isEmpty && _hasSend) {
                      _hasSend = false;
                      setState(() {});
                    } else if (_textMessage.text.isNotEmpty && !_hasSend) {
                      _hasSend = true;
                      setState(() {});
                    }
                  },
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 24,
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: Text(S.current.txt_no_recents,
                        style: BaseTextStyle.caption(),
                        textAlign: TextAlign.center),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                    checkPlatformCompatibility: true,
                  ),
                ),
              ),
            )
          ]),
        ),
      ]),
    );
  }

  _send(SendMessageRequest request) {
    GetIt.instance.get<MessageCubit>().sendMessage(request);
  }

  _onEditingComplete() {
    if (_hasSend) {
      _send(
        SendMessageRequest(
          groupId: widget.groupId,
          content: _textMessage.text,
        ),
      );
      _textMessage.clear();
    }
  }
}

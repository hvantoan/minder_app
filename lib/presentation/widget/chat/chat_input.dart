import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/data/model/chat/send_message_request.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/chat/chat_cubit.dart';
import 'package:minder/presentation/bloc/message/message_cubit.dart';
import 'package:minder/presentation/widget/image_helper/grid_gallery.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_shadow_style.dart';
import 'package:minder/util/style/base_text_style.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.groupId, this.onFocus});

  final String groupId;
  final VoidCallback? onFocus;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final key = GlobalKey<EmojiPickerState>();
  bool _emojiShowing = false;
  bool _hasSend = false;
  bool _imageShowing = false;
  final TextEditingController _textMessage = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        if (_emojiShowing) {
          GetIt.instance
              .get<ChatCubit>()
              .changeDisplayEmojiPicker(_emojiShowing);
        }

        if (_imageShowing) {
          GetIt.instance
              .get<ChatCubit>()
              .changeDisplayImagePicker(_imageShowing);
        }
        if (widget.onFocus != null) widget.onFocus;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is SendButtonState) {
          _hasSend = state.hasSend;
        }

        if (state is EmojiPickerDisplayState) {
          Future.delayed(Duration(
                  milliseconds:
                      state.emojiShowing && _focusNode.hasFocus ? 5 : 0))
              .then((value) {
            if (state.emojiShowing) {
              _imageShowing = false;
            }
            _emojiShowing = state.emojiShowing;
          });
        }

        if (state is ImagePickerState) {
          Future.delayed(Duration(
            milliseconds: state.imageShowing && _focusNode.hasFocus ? 5 : 0,
          )).then((value) {
            _imageShowing = state.imageShowing;
            _emojiShowing = false;
          });
        }
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        if (_focusNode.hasFocus) {
                          _focusNode.unfocus();
                        }
                        GetIt.instance
                            .get<ChatCubit>()
                            .changeDisplayImagePicker(_imageShowing);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset(
                          IconPath.pictureLine,
                          color: BaseColor.green500,
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _textMessage,
                        textAlignVertical: TextAlignVertical.center,
                        style: BaseTextStyle.body2(),
                        minLines: 1,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        focusNode: _focusNode,
                        onChanged: (value) {
                          GetIt.instance
                              .get<ChatCubit>()
                              .changeButtonSendState(value);
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          fillColor: BaseColor.grey100,
                          filled: true,
                          isDense: true,
                          hintText: S.current.txt_write_something,
                          hintStyle: BaseTextStyle.body2(),
                          contentPadding: const EdgeInsets.all(8),
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (_focusNode.hasFocus) {
                                _focusNode.unfocus();
                              }
                              GetIt.instance
                                  .get<ChatCubit>()
                                  .changeDisplayEmojiPicker(_emojiShowing);
                            },
                            icon: BaseIcon.base(IconPath.emojiLine,
                                color: BaseColor.grey300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: BaseColor.grey100, width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: BaseColor.grey100, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: BaseColor.grey100, width: 1.0),
                          ),
                        ),
                        onEditingComplete: () => _send(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _send();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: !_hasSend ? BaseColor.grey100 : null,
                          gradient: _hasSend
                              ? const LinearGradient(colors: [
                                  BaseColor.green300,
                                  BaseColor.green500
                                ])
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
                    height: 250,
                    child: EmojiPicker(
                      textEditingController: _textMessage,
                      key: key,
                      onEmojiSelected: (category, emoji) {
                        if (!_hasSend) {
                          GetIt.instance
                              .get<ChatCubit>()
                              .changeButtonSendState(_textMessage.text);
                        }
                      },
                      config: const Config(emojiSizeMax: 24, columns: 9),
                    ),
                  ),
                ),
                Offstage(
                  offstage: !_imageShowing,
                  child: const SizedBox(height: 250, child: GridGallery()),
                )
              ]),
            ),
          ]),
        );
      },
    );
  }

  _send() {
    if (_hasSend) {
      GetIt.instance.get<MessageCubit>().sendMessage(
            SendMessageRequest(
              groupId: widget.groupId,
              content: _textMessage.text,
            ),
          );
      _textMessage.clear();
    }
  }
}

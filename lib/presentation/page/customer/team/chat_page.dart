import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/data/model/chat/list_message_request.dart';
import 'package:minder/domain/entity/chat/message.dart';
import 'package:minder/presentation/bloc/message/message_cubit.dart';
import 'package:minder/presentation/widget/message/text_message.dart';
import 'package:minder/presentation/widget/message/time_line_message.dart';

const double _padding = 16;

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.groupId,
      required this.height,
      required this.isScroll});

  final double height;
  final String groupId;
  final bool isScroll;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _controller = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _enableScrollEnd = false;
  List<Message> _messages = List.empty(growable: true);
  final ListMessageRequest _request = ListMessageRequest(groupId: "");

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.position.pixels <
              _controller.positions.last.maxScrollExtent &&
          !_enableScrollEnd) {
        _enableScrollEnd = true;
      } else if (_enableScrollEnd) {
        _enableScrollEnd = false;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _request.groupId = widget.groupId;
    return BlocBuilder<MessageCubit, MessageState>(
        bloc: GetIt.instance.get<MessageCubit>()..getMessage(_request),
        builder: (context, state) {
          if (state is OnUpdateMessageState) {
            _messages = state.message;
            _jumpToEnd(true);
          }

          if (state is OnLoadMessageState) {
            GetIt.instance.get<MessageCubit>().getMessage(_request);
          }

          if (state is MessageErrorState) {
            return Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    Text("Đang tải...")
                  ]),
            );
          }
          return _buildMessage();
        });
  }

  Widget _buildMessage() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _controller,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  SizedBox(
                      height: _padding +
                          (widget.isScroll ? 0 : widget.height - 64)),
                  ...List.generate(
                    _messages.length,
                    (index) {
                      var message = _messages[index];
                      switch (message.messageType) {
                        case 3:
                          return TimeLineMessage(message: message);
                      }
                      return TextMessage(message: message);
                    },
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ),
          // SizedBox(
          //     height: widget.height + MediaQuery.of(context).viewInsets.bottom)
        ],
      ),
    );
  }

  _jumpToEnd(bool delay) {
    Future.delayed(Duration(milliseconds: delay ? 400 : 0), () {
      if (_controller.positions.isNotEmpty) {
        _controller.jumpTo(_controller.positions.last.maxScrollExtent);
      }
    });
  }
}

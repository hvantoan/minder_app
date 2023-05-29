import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/data/model/chat/list_message_request.dart';
import 'package:minder/domain/entity/chat/message.dart';
import 'package:minder/domain/entity/group/group.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/message/message_cubit.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/chat/chat_input.dart';
import 'package:minder/presentation/widget/message/text_message.dart';
import 'package:minder/presentation/widget/message/time_line_message.dart';
import 'package:minder/util/style/base_style.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({
    super.key,
    required this.group,
    this.appBarDisplay = true,
  });

  final Group group;
  final bool appBarDisplay;
  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ScrollController _controller = ScrollController();
  List<Message> _messages = List.empty(growable: true);
  List<Message> loadingMessage = List.empty(growable: true);
  ListMessageRequest req =
      ListMessageRequest(groupId: "", pageIndex: 0, pageSize: 20);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    GetIt.instance.get<MessageCubit>().reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    req.groupId = widget.group.id;

    return Scaffold(
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: widget.appBarDisplay
          ? ChatInput(
              groupId: widget.group.id,
              onFocus: () => _jumpToEnd(true),
            )
          : null,
      body: _buildBody(),
    );
  }

  AppBar? _buildAppBar() {
    if (widget.appBarDisplay) {
      return AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.25),
        toolbarHeight: 56,
        iconTheme: const IconThemeData(
          color: BaseColor.grey900,
        ),
        title: Row(
          children: [
            AvatarWidget.base(size: 32, imagePath: widget.group.avatar),
            const SizedBox(width: 16),
            Text(widget.group.title, style: BaseTextStyle.label()),
          ],
        ),
      );
    }
    return null;
  }

  Widget _buildBody() {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: GetIt.instance.get<MessageCubit>()..getMessage(req),
      builder: (context, state) {
        if (state is MessageInitial) {
          GetIt.instance.get<MessageCubit>().getMessage(req);
        }

        if (state is MessageLoadedState) {
          if (loadingMessage.isNotEmpty) {
            loadingMessage.removeAt(0);
          }
          _messages = state.messages;
          _jumpToEnd(true);
        }

        if (state is SendingMessageState) {
          loadingMessage.add(state.message);
          _jumpToEnd(true);
        }

        if (state is SendedMessageState) {
          GetIt.instance.get<MessageCubit>().getMessage(req);
        }

        if (_messages.isEmpty) {
          return Center(
              child: Text(
            S.current.txt_no_message,
            style: BaseTextStyle.body1(),
          ));
        }
        return GestureDetector(
          onTap: () => FocusManager,
          child: SingleChildScrollView(
            controller: _controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ...List.generate(
                    _messages.length,
                    (index) {
                      var message = _messages[index];
                      switch (message.messageType) {
                        case 1:
                          return Container();
                        case 2:
                          return Container();
                        case 3:
                          return TimeLineMessage(message: message);
                        case 4:
                          return Container();
                      }
                      return TextMessage(message: message);
                    },
                  ),
                  ...List.generate(loadingMessage.length,
                      (index) => TextMessage(message: loadingMessage[index])),
                  const SizedBox(height: 16)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _jumpToEnd(bool delay) {
    Future.delayed(Duration(milliseconds: delay ? 100 : 0), () {
      if (_controller.positions.isNotEmpty) {
        _controller.jumpTo(_controller.positions.last.maxScrollExtent);
      }
    });
  }
}

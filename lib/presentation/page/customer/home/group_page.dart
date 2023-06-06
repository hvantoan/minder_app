import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/domain/entity/group/group.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/group/group_cubit.dart';
import 'package:minder/presentation/page/customer/home/conversation_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_size.dart';
import 'package:minder/util/style/base_style.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Group> groups = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        if (state is GroupLoadedState) {
          groups = state.groups;
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: appBarSize,
              title: Text(
                S.current.lbl_chat,
                style: BaseTextStyle.label(),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: BaseIcon.base(IconPath.pencilLine,
                      size: const Size(24, 24)),
                )
              ],
              shadowColor: BaseColor.grey500.withOpacity(0.08),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (context, index) => _group(groups[index]),
            ),
          ),
        );
      },
    );
  }

  _group(Group group) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ConversationPage(
                group: group,
              ))),
      child: Container(
        margin:
            const EdgeInsets.only(top: padding, left: padding, right: padding),
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(16),
          boxShadow: [BaseShadowStyle.common],
        ),
        child: Row(
          children: [
            AvatarWidget.base(
                size: 48, imagePath: group.avatar, name: group.title),
            const SizedBox(width: padding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.title,
                  style: BaseTextStyle.label(),
                ),
                const SizedBox(height: 8),
                Text(
                  group.lastMessage,
                  style: BaseTextStyle.caption(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

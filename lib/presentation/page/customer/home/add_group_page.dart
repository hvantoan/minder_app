import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/data/repository/implement/group_repository_impl.dart';
import 'package:minder/data/repository/implement/user_repository_impl.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/group/group_cubit.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/style/base_size.dart';
import 'package:minder/util/style/base_style.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});
  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  List<String> selectedUserIds = List.empty(growable: true);
  TextEditingController searchText = TextEditingController();
  List<User> users = List.empty(growable: true);
  List<User> display = List.empty(growable: true);

  Future<List<User>> _fetchData() async {
    if (users.isNotEmpty) return users;
    return UserRepository().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          users = snapshot.data ?? [];
          if (searchText.text.isNotEmpty) {
            display = users
                .where((element) => element.name!
                    .toLowerCase()
                    .contains(searchText.text.toLowerCase()))
                .toList();
          } else {
            display = users;
          }
        }
        return Scaffold(
          appBar: _buildAppBar(context),
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: padding, right: padding, left: padding),
                  child: TextFieldWidget.base(
                    hintText: S.current.txt_search,
                    onChanged: (name) {
                      searchText.text = name;
                      setState(() {});
                    },
                    suffixIconPath: IconPath.searchLine,
                  ),
                ),
                const SizedBox(height: 16),
                _buildListUser(snapshot.connectionState),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Expanded _buildListUser(ConnectionState state) {
    if (state == ConnectionState.waiting && users.isEmpty) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: display.length,
        itemBuilder: (context, index) => _buildUserItem(
          user: display[index],
          selectedUserIds: selectedUserIds,
          onClick: (id) {
            var findId = selectedUserIds.where((element) => element == id);
            if (findId.isNotEmpty) {
              selectedUserIds.remove(findId.first);
            } else {
              selectedUserIds.add(id);
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 56,
      title: Text(S.current.lbl_create_group, style: BaseTextStyle.label()),
      centerTitle: true,
      shadowColor: Colors.black.withOpacity(0.25),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                if (selectedUserIds.isNotEmpty) {
                  GetIt.instance.get<LoadingCoverController>().on(context);
                  GroupRepository()
                      .create(userIds: selectedUserIds)
                      .then((value) {
                    GetIt.instance
                        .get<GroupCubit>()
                        .load(pageIndex: 0, pageSize: 100);
                    GetIt.instance.get<LoadingCoverController>().off(context);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(S.current.txt_done,
                  style: BaseTextStyle.body1(color: BaseColor.green500)),
            ),
          ),
        ),
      ],
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(S.current.txt_cancel,
                style: BaseTextStyle.body1(color: BaseColor.grey900)),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  _buildUserItem(
      {required User user,
      required List<String> selectedUserIds,
      required Function(String) onClick}) {
    return GestureDetector(
      onTap: () => onClick(user.id ?? ""),
      child: Container(
        margin:
            const EdgeInsets.only(top: padding, left: padding, right: padding),
        padding: const EdgeInsets.all(padding / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [BaseShadowStyle.appBar],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AvatarWidget.base(imagePath: user.avatar, size: 32),
                const SizedBox(width: padding),
                Text(user.name ?? "", style: BaseTextStyle.body2()),
              ],
            ),
            Checkbox(
              value: selectedUserIds.contains(user.id),
              onChanged: (check) {},
            )
          ],
        ),
      ),
    );
  }
}

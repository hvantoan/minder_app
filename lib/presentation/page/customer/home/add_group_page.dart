import 'package:flutter/material.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_size.dart';
import 'package:minder/util/style/base_style.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key, required this.users});
  final List<User> users;
  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  List<String> selectedUserIds = List.empty(growable: true);
  TextEditingController searchText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: BaseColor.grey200, width: 1))),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 32,
                  child: Text(S.current.lbl_create_group,
                      style: BaseTextStyle.label(color: BaseColor.grey900)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(S.current.btn_done,
                        style: BaseTextStyle.label(color: BaseColor.green500)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: padding, right: padding, left: padding),
            child: TextFieldWidget.base(
              hintText: S.current.txt_search,
              onChanged: (name) {},
              suffixIconPath: IconPath.searchLine,
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: (context, index) => _buildUserItem(
              user: widget.users[index],
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
          ))
        ],
      ),
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

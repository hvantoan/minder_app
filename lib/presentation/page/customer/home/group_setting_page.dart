import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minder/data/repository/implement/group_repository_impl.dart';
import 'package:minder/domain/entity/group/group.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/group/group_cubit.dart';
import 'package:minder/presentation/widget/image_picker/image_picker_widget.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/style/base_style.dart';

class GroupSettingPage extends StatefulWidget {
  const GroupSettingPage({super.key, required this.group});
  final Group group;

  @override
  State<GroupSettingPage> createState() => _GroupSettingPageState();
}

class _GroupSettingPageState extends State<GroupSettingPage> {
  File? avatar;
  String? nameErrorText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildUpdateForm(),
        ],
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      toolbarHeight: 56,
      title: Text(S.current.lbl_update_group, style: BaseTextStyle.label()),
      centerTitle: true,
      shadowColor: Colors.black.withOpacity(0.25),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                if (widget.group.title.isEmpty) {
                  nameErrorText = S.current.txt_err_group_name;
                  return;
                }
                GetIt.instance.get<LoadingCoverController>().on(context);
                GroupRepository()
                    .update(
                        groupId: widget.group.id,
                        groupName: widget.group.title,
                        avatar: avatar)
                    .then((value) {
                  GetIt.instance
                      .get<GroupCubit>()
                      .load(pageIndex: 0, pageSize: 100);
                  GetIt.instance.get<LoadingCoverController>().off(context);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
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

  _buildUpdateForm() {
    final Group group = widget.group;
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget.title(title: S.current.lbl_avatar),
            Center(
                child: ImagePickerWidget.addCircle(
                    url: group.avatar,
                    imagePath: avatar,
                    onTap: () => pickImage())),
            TextWidget.title(title: S.current.lbl_group_name),
            TextFieldWidget.common(
              onChanged: (text) {
                widget.group.title = text;
              },
              initialValue: widget.group.title,
              errorText: nameErrorText,
            ),
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        avatar = File(result.path);
      });
    }
  }
}

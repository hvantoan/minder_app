import 'package:flutter/material.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_text_style.dart';

class RemoveMemberPage extends StatefulWidget {
  final Member member;

  const RemoveMemberPage({Key? key, required this.member}) : super(key: key);

  @override
  State<RemoveMemberPage> createState() => _RemoveMemberPageState();
}

class _RemoveMemberPageState extends State<RemoveMemberPage> {
  final TextEditingController memberNameController = TextEditingController();
  String? _memberNameErrorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget.common(
            onChanged: (value) {},
            labelText: S.current.lbl_member_name,
            hintText: S.current.txt_enter_member_name,
            required: true,
            prefixIconPath: IconPath.mailLine),
        const SizedBox(height: 24),
        if (_memberNameErrorText != null)
          Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(_memberNameErrorText!,
                  style: BaseTextStyle.body2(color: BaseColor.red500))),
        ButtonWidget.primary(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.success(
                  context: context,
                  title: S.current.lbl_success,
                  subtitle:
                  "${memberNameController.text} ${S.current
                      .txt_eliminated_from_team}",
                  isClosable: false));
            },
            content: S.current.btn_verify),
      ],
    );
  }
}

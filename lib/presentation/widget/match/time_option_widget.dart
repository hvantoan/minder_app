import 'package:flutter/material.dart';
import 'package:minder/domain/entity/match/match.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/dialog/dialog_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class TimeOptionWidget {
  static base(TimeOption timeOption, bool isSelected, VoidCallback? onTap,
      BuildContext context) {
    final count = timeOption.memberCount ?? 0;
    final bool isValid = count == 0 ? true : count > 5;
    return GestureDetector(
      onTap: isValid
          ? () {
              if (count == 0) {
                onTap!.call();
                return;
              }
              if (count > 5 && count < 10) {
                DialogWidget.show(
                  context: context,
                  alert: DialogWidget.base(
                      title: S.current.lbl_no_enough_number_member,
                      subtitle: S.current.txt_sure_to_choose_this_time,
                      actions: [
                        ButtonWidget.primary(
                            onTap: () {
                              Navigator.pop(context);
                              onTap!.call();
                            },
                            content: S.current.btn_agree),
                        ButtonWidget.secondary(
                            onTap: () => Navigator.pop(context),
                            content: S.current.btn_cancel),
                      ]),
                );
                return;
              }
            }
          : null,
      child: Container(
        width: double.infinity,
        height: 40,
        margin: const EdgeInsets.only(top: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: isSelected
                ? BaseColor.green500
                : (isValid ? Colors.white : BaseColor.grey100),
            border: isValid ? Border.all(color: BaseColor.grey200) : null),
        child: Row(
          children: [
            Expanded(
              child: Text(
                timeOption.displayTime ?? "",
                style: BaseTextStyle.body1(
                    color: isSelected
                        ? Colors.white
                        : (isValid ? null : BaseColor.grey500)),
              ),
            ),
            if (timeOption.memberCount != 0)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Text(
                      timeOption.memberCount?.toString() ?? "",
                      style: BaseTextStyle.body1(
                          color: isSelected
                              ? Colors.white
                              : (isValid ? null : BaseColor.grey500)),
                    ),
                  ),
                  BaseIcon.base(IconPath.userLine,
                      color: isSelected
                          ? Colors.white
                          : (isValid ? null : BaseColor.grey500))
                ],
              )
          ],
        ),
      ),
    );
  }
}

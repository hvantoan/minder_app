import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/style/base_style.dart';

// ignore: must_be_immutable
class SexSetting extends StatefulWidget {
  SexSetting({
    super.key,
    required this.context,
    required this.sexs,
    required this.onSuccess,
    required this.value,
  });

  final BuildContext context;
  final List<Map<String, Object>> sexs;
  final Function(int) onSuccess;
  int value;

  @override
  State<SexSetting> createState() => _SexSettingState();
}

class _SexSettingState extends State<SexSetting> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
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
                child: Text(S.current.lbl_sex, style: BaseTextStyle.label()),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    widget.onSuccess(widget.value);
                    Navigator.of(context).pop();
                  },
                  child: Text(S.current.btn_done,
                      style: BaseTextStyle.label(color: BaseColor.green500)),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              widget.sexs.length,
              (idx) => sexItem(
                context: context,
                onIndexChange: (value) {
                  setState(() {
                    widget.value = value;
                  });
                },
                value: widget.value,
                sex: widget.sexs[idx],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sexItem({
    required BuildContext context,
    required Function(int) onIndexChange,
    required int value,
    required Map<String, Object> sex,
  }) {
    return GestureDetector(
      onTap: () {
        onIndexChange(sex['value'] as int);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color: (value == sex['value'])
                ? BaseColor.grey100
                : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                height: 32,
                child: Image.asset(sex['imagePath'] as String),
              ),
              const SizedBox(width: 16),
              Text(
                sex['name'] as String,
                style: BaseTextStyle.body1(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

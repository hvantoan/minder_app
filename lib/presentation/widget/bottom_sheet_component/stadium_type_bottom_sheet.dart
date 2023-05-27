// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/style/base_style.dart';

class StadiumTypeSetting extends StatefulWidget {
  StadiumTypeSetting({
    super.key,
    required this.context,
    required this.stadiumTypes,
    required this.types,
    required this.onSuccess,
  });

  final BuildContext context;
  final List<Map<String, Object>> stadiumTypes;
  final Function(List<int>) onSuccess;
  List<int> types;

  @override
  State<StadiumTypeSetting> createState() => _StadiumTypeSettingState();
}

class _StadiumTypeSettingState extends State<StadiumTypeSetting> {
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
                child: Text(S.current.lbl_stadium_type,
                    style: BaseTextStyle.label(color: BaseColor.grey900)),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    widget.onSuccess(widget.types);
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
              widget.stadiumTypes.length,
              (idx) => stadiumTypeItem(
                context: context,
                onCheckChange: (value) {
                  if (widget.types.any((element) => element == value)) {
                    setState(() {
                      widget.types = widget.types
                          .where((element) => element != value)
                          .toList();
                    });
                  } else {
                    setState(() {
                      widget.types.add(value);
                    });
                  }
                },
                types: widget.types,
                stadiumType: widget.stadiumTypes[idx],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget stadiumTypeItem({
    required BuildContext context,
    required Function(int) onCheckChange,
    required List<int> types,
    required Map<String, Object> stadiumType,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: stadiumType['index'] == 5 ? 0 : 4),
      child: GestureDetector(
        onTap: () {
          onCheckChange(stadiumType['index'] as int);
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
              color: (types.any((element) => element == stadiumType['index']))
                  ? BaseColor.grey100
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  stadiumType['name'] as String,
                  style: BaseTextStyle.body1(
                    color: BaseColor.grey900,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

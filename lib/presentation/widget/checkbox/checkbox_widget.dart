import 'package:flutter/material.dart';
import 'package:minder/util/style/base_style.dart';

class CheckBoxWidget {
  static base(
      {required bool currentValue,
      required ValueChanged<bool?> onChanged,
      String? label}) {
    return Row(
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              side: const BorderSide(color: BaseColor.grey200),
              value: currentValue,
              onChanged: onChanged,
              activeColor: BaseColor.green500),
        ),
        if (label != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                label,
                style: BaseTextStyle.body1(),
              ),
            ),
          )
      ],
    );
  }
}

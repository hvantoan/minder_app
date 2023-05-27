import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/chip/chip_widget.dart';
import 'package:minder/util/constant/enum/position_enum.dart';

class PositionHelper {
  static String mapKeyToTitle(Position position) {
    switch (position) {
      case Position.gk:
        return S.current.txt_gk;
      case Position.cb:
        return S.current.txt_cb;
      case Position.cm:
        return S.current.txt_cm;
      case Position.st:
        return S.current.txt_st;
      default:
        return "";
    }
  }

  static Widget mapKeyToChip(Position position) {
    switch (position) {
      case Position.gk:
        return ChipWidget.gk();
      case Position.cb:
        return ChipWidget.cb();
      case Position.cm:
        return ChipWidget.cm();
      case Position.st:
        return ChipWidget.st();
      default:
        return const SizedBox.shrink();
    }
  }
}

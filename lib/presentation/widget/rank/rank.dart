import 'package:flutter/cupertino.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';

class Rank {
  static Widget edit(
      {required int rank, required Function(int) onValueChange}) {
    return Row(
      children: List.generate(
        5,
        (index) => _star(
          rank: rank,
          index: index + 1,
          onClick: onValueChange,
        ),
      ),
    );
  }

  static Widget view({required int rank}) {
    return Row(
      children: List.generate(
        5,
        (index) => _star(
          rank: rank,
          index: index + 1,
          onClick: (e) {},
        ),
      ),
    );
  }

  static Widget _star(
      {required int rank, required int index, required Function(int) onClick}) {
    return GestureDetector(
      onTap: () => onClick(index),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: rank >= index
            ? BaseIcon.base(IconPath.starFill, color: BaseColor.yellow500)
            : BaseIcon.base(IconPath.starLine, color: BaseColor.grey300),
      ),
    );
  }
}

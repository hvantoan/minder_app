import 'package:flutter/material.dart';
import 'package:minder/util/style/base_style.dart';

class PositionPlay {
  static Widget view({required List<int> positions}) {
    final data = [
      {
        "value": 0,
        "name": "Tiền đạo",
        "backgroundColor": BaseColor.blue100,
        "textColor": BaseColor.blue700
      },
      {
        "value": 1,
        "name": "Trung vệ",
        "backgroundColor": BaseColor.green100,
        "textColor": BaseColor.green700
      },
      {
        "value": 2,
        "name": "Hậu vệ",
        "backgroundColor": BaseColor.yellow100,
        "textColor": BaseColor.yellow700
      },
      {
        "value": 3,
        "name": "Thủ môn",
        "backgroundColor": BaseColor.red100,
        "textColor": BaseColor.red700
      },
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          positions.length,
          (index) {
            var item = data.firstWhere((o) => o["value"] == positions[index]);
            return buildItem(
                name: item["name"] as String,
                color: item["backgroundColor"] as Color,
                textColor: item["textColor"] as Color);
          },
        ),
      ),
    );
  }

  static Widget edit({
    required List<int> positions,
    required Function(List<int>) onValueChange,
  }) {
    final data = [
      {
        "value": 0,
        "name": "Tiền đạo",
      },
      {
        "value": 1,
        "name": "Trung vệ",
      },
      {
        "value": 2,
        "name": "Hậu vệ",
      },
      {
        "value": 3,
        "name": "Thủ môn",
      },
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          data.length,
          (index) {
            var item = data[index];

            var isActive = positions.any((e) => e == item["value"]);
            return GestureDetector(
              onTap: () {
                var hasValue =
                    positions.any((element) => element == item.values.first);
                if (hasValue) {
                  positions = positions
                      .where((element) => element != item.values.first)
                      .toList();
                } else {
                  positions.add(item.values.first as int);
                }
                onValueChange(positions);
              },
              child: buildItem(
                name: item["name"] as String,
                color: isActive ? BaseColor.green700 : Colors.white,
                textColor: isActive ? Colors.white : BaseColor.grey500,
              ),
            );
          },
        ),
      ),
    );
  }

  static Padding buildItem({
    required String name,
    Color color = BaseColor.grey500,
    Color textColor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: textColor == BaseColor.grey500
              ? Border.all(color: BaseColor.grey500, width: 0.5)
              : null,
        ),
        child: Text(name, style: BaseTextStyle.body1(color: textColor)),
      ),
    );
  }
}

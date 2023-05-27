import 'package:flutter/material.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_text_style.dart';

class TimeWidget extends StatefulWidget {
  final GameTime gameTime;
  final List<GameTime>? gameTimes;
  final bool isEdit;
  final ValueChanged<GameTime>? onChanged;

  const TimeWidget({Key? key,
    required this.gameTime,
    this.gameTimes,
    required this.isEdit,
    this.onChanged})
      : super(key: key);

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  final List<num> monday = List.empty(growable: true);
  final List<num> tuesday = List.empty(growable: true);
  final List<num> wednesday = List.empty(growable: true);
  final List<num> thursday = List.empty(growable: true);
  final List<num> friday = List.empty(growable: true);
  final List<num> saturday = List.empty(growable: true);
  final List<num> sunday = List.empty(growable: true);
  final List<int> mondayHours = List.generate(24, (index) => 0);
  final List<int> tuesdayHours = List.generate(24, (index) => 0);
  final List<int> wednesdayHours = List.generate(24, (index) => 0);
  final List<int> thursdayHours = List.generate(24, (index) => 0);
  final List<int> fridayHours = List.generate(24, (index) => 0);
  final List<int> saturdayHours = List.generate(24, (index) => 0);
  final List<int> sundayHours = List.generate(24, (index) => 0);

  final List<String> _tableHeaderString = [
    S.current.txt_hour,
    S.current.txt_m,
    S.current.txt_t,
    S.current.txt_w,
    S.current.txt_th,
    S.current.txt_f,
    S.current.txt_s,
    S.current.txt_su
  ];

  GameTime gameTime = GameTime();

  @override
  void didUpdateWidget(covariant TimeWidget oldWidget) {
    if (!widget.isEdit) setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    gameTime = widget.gameTime;
    setup();
    final gameTimes = widget.gameTimes;
    if (gameTimes != null) {
      for (var element in gameTimes) {
        if (element.monday != null && element.monday!.isNotEmpty) {
          for (var hour in element.monday!) {
            mondayHours[hour.toInt() - 1]++;
          }
        }
        if (element.tuesday != null && element.tuesday!.isNotEmpty) {
          for (var hour in element.tuesday!) {
            tuesdayHours[hour.toInt() - 1]++;
          }
        }
        if (element.wednesday != null && element.wednesday!.isNotEmpty) {
          for (var hour in element.wednesday!) {
            wednesdayHours[hour.toInt() - 1]++;
          }
        }
        if (element.thursday != null && element.thursday!.isNotEmpty) {
          for (var hour in element.thursday!) {
            thursdayHours[hour.toInt() - 1]++;
          }
        }
        if (element.friday != null && element.friday!.isNotEmpty) {
          for (var hour in element.friday!) {
            fridayHours[hour.toInt() - 1]++;
          }
        }
        if (element.saturday != null && element.saturday!.isNotEmpty) {
          for (var hour in element.saturday!) {
            saturdayHours[hour.toInt() - 1]++;
          }
        }
        if (element.sunday != null && element.sunday!.isNotEmpty) {
          for (var hour in element.sunday!) {
            sundayHours[hour.toInt() - 1]++;
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageSize = MediaQuery
        .of(context)
        .size;
    return Column(
      children: [
        _header(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Row(
              children: [
                Column(
                  children: List.generate(
                      24,
                          (index) =>
                          _cell(
                              "${(index + 1) < 10 ? "0" : ""}${index + 1}",
                              pageSize.width / 8,
                              48.0)),
                ),
                Expanded(
                  child: Table(
                    border: TableBorder.all(color: BaseColor.grey200),
                    children: List.generate(24, (row) {
                      return TableRow(
                          children: List.generate(7, (cell) {
                            final check = isExist(cell, row);
                            final num = getNum(cell, row);
                            return TableCell(
                              verticalAlignment: TableCellVerticalAlignment
                                  .middle,
                              child: GestureDetector(
                                onTap: () =>
                                widget.isEdit ? select(cell, row) : null,
                                child: Container(
                                  height: 48,
                                  width: pageSize.width / 8,
                                  alignment: Alignment.center,
                                  color: check
                                      ? BaseColor.green400
                                      : Colors.transparent,
                                  child: num > 0
                                      ? Text(
                                    num.toString(),
                                    style: BaseTextStyle.label(
                                        color: check
                                            ? Colors.white
                                            : BaseColor.grey300),
                                  )
                                      : null,
                                ),
                              ),
                            );
                          }));
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final pageSize = MediaQuery
        .of(context)
        .size;
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: _tableHeaderString
            .map((e) =>
            _cell(e, pageSize.width / _tableHeaderString.length, 48.0))
            .toList(),
      ),
    );
  }

  Widget _cell(String title, double width, double? height) {
    return Container(
      width: width,
      height: height ?? 48,
      alignment: Alignment.center,
      child: Text(
        title,
        style: BaseTextStyle.label(color: BaseColor.grey500),
      ),
    );
  }

  void setup() {
    monday.clear();
    tuesday.clear();
    wednesday.clear();
    thursday.clear();
    friday.clear();
    saturday.clear();
    sunday.clear();

    if (gameTime.monday != null) monday.addAll(gameTime.monday!);
    if (gameTime.tuesday != null) tuesday.addAll(gameTime.tuesday!);
    if (gameTime.wednesday != null) wednesday.addAll(gameTime.wednesday!);
    if (gameTime.thursday != null) thursday.addAll(gameTime.thursday!);
    if (gameTime.friday != null) friday.addAll(gameTime.friday!);
    if (gameTime.saturday != null) saturday.addAll(gameTime.saturday!);
    if (gameTime.sunday != null) sunday.addAll(gameTime.sunday!);
  }

  bool isExist(int cell, int row) {
    num hour = row + 1;
    switch (cell) {
      case 0:
        return monday.contains(hour);
      case 1:
        return tuesday.contains(hour);
      case 2:
        return wednesday.contains(hour);
      case 3:
        return thursday.contains(hour);
      case 4:
        return friday.contains(hour);
      case 5:
        return saturday.contains(hour);
      case 6:
        return sunday.contains(hour);
      default:
        return false;
    }
  }

  int getNum(int cell, int row) {
    int index = row;
    switch (cell) {
      case 0:
        return mondayHours[index].toInt();
      case 1:
        return tuesdayHours[index].toInt();
      case 2:
        return wednesdayHours[index].toInt();
      case 3:
        return thursdayHours[index].toInt();
      case 4:
        return fridayHours[index].toInt();
      case 5:
        return saturdayHours[index].toInt();
      case 6:
        return sundayHours[index].toInt();
      default:
        return 0;
    }
  }

  void select(int cell, int row) {
    num hour = row + 1;
    switch (cell) {
      case 0:
        if (monday.contains(hour)) {
          monday.remove(hour);
        } else {
          monday.add(hour);
        }
        break;
      case 1:
        if (tuesday.contains(hour)) {
          tuesday.remove(hour);
        } else {
          tuesday.add(hour);
        }
        break;
      case 2:
        if (wednesday.contains(hour)) {
          wednesday.remove(hour);
        } else {
          wednesday.add(hour);
        }
        break;
      case 3:
        if (thursday.contains(hour)) {
          thursday.remove(hour);
        } else {
          thursday.add(hour);
        }
        break;
      case 4:
        if (friday.contains(hour)) {
          friday.remove(hour);
        } else {
          friday.add(hour);
        }
        break;
      case 5:
        if (saturday.contains(hour)) {
          saturday.remove(hour);
        } else {
          saturday.add(hour);
        }
        break;
      case 6:
        if (sunday.contains(hour)) {
          sunday.remove(hour);
        } else {
          sunday.add(hour);
        }
        break;
    }
    setState(() {});
    if (widget.onChanged != null) {
      widget.onChanged?.call(GameTime(
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
          sunday: sunday));
    }
  }
}

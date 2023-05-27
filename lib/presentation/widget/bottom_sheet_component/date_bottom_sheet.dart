import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/style/base_style.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

// ignore: must_be_immutable
class DateBottomSheet extends StatefulWidget {
  DateBottomSheet({
    super.key,
    this.dob,
    required this.onSuccess,
  });

  DateTime? dob;
  final Function(DateTime?) onSuccess;

  @override
  State<DateBottomSheet> createState() => _DateBottomSheetState();
}

class _DateBottomSheetState extends State<DateBottomSheet> {
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
                child: Text(S.current.lbl_birthday,
                    style: BaseTextStyle.label(color: BaseColor.grey900)),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    widget.onSuccess(widget.dob);
                    Navigator.of(context).pop();
                  },
                  child: Text(S.current.txt_done,
                      style: BaseTextStyle.label(color: BaseColor.green500)),
                ),
              ),
            ],
          ),
        ),
        CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            calendarType: CalendarDatePicker2Type.single,
            weekdayLabelTextStyle: BaseTextStyle.body1(),
            firstDayOfWeek: 0,
            dayTextStyle: BaseTextStyle.body1(color: BaseColor.grey500),
            currentDate: DateTime.now(),
            selectedDayTextStyle: BaseTextStyle.body1(color: Colors.white),
            dayBorderRadius: BorderRadius.circular(8),
            lastDate: DateTime.now(),
          ),
          value: [widget.dob],
          onValueChanged: (dates) => widget.dob = dates.first,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/page/customer/team/find_team/select_match_type_page.dart';
import 'package:minder/presentation/page/customer/team/find_team/select_number_of_member_page.dart';
import 'package:minder/presentation/widget/chip/chip_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/enum/position_enum.dart';
import 'package:minder/util/constant/enum/weekday_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/helper/age_helper.dart';
import 'package:minder/util/helper/position_helper.dart';
import 'package:minder/util/helper/stadium_type_helper.dart';
import 'package:minder/util/helper/time_helper.dart';
import 'package:minder/util/helper/weekday_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_shadow_style.dart';
import 'package:minder/util/style/base_text_style.dart';

const double _appBarHeight = 56.0;

class FilterTeamPage extends StatefulWidget {
  final int? preRate;
  final int? preNumberOfMembers;
  final List<int>? preAverageAge;
  final List<int>? preMatchType;
  final List<Position>? prePosition;
  final List<Weekday>? preWeekday;
  final List<int>? preTime;

  const FilterTeamPage(
      {Key? key,
      this.preRate,
      this.preNumberOfMembers,
      this.preAverageAge,
      this.preMatchType,
      this.prePosition,
      this.preWeekday,
      this.preTime})
      : super(key: key);

  @override
  State<FilterTeamPage> createState() => _FilterTeamPageState();
}

class _FilterTeamPageState extends State<FilterTeamPage> {
  int? currentRate;
  int? selectedNumberOfMembers;
  final List<int> selectedAverageAge = List.empty(growable: true);
  final List<int> selectedMatchType = List.empty(growable: true);
  final List<Position> selectedPosition = List.empty(growable: true);
  final List<Weekday> selectedWeekday = List.empty(growable: true);
  final List<int> selectedTime = List.empty(growable: true);

  final TextEditingController numberMemberController = TextEditingController();
  final TextEditingController matchTypeController = TextEditingController();

  @override
  void initState() {
    setState(() {
      if (widget.preRate != null) currentRate = widget.preRate!;
      if (widget.preNumberOfMembers != null) {
        selectedNumberOfMembers = widget.preNumberOfMembers;
      }
      if (widget.preAverageAge != null) {
        selectedAverageAge.addAll(widget.preAverageAge!);
      }
      if (widget.preMatchType != null) {
        selectedMatchType.addAll(widget.preMatchType!);
      }
      if (widget.prePosition != null) {
        selectedPosition.addAll(widget.prePosition!);
      }
      if (widget.preWeekday != null) selectedWeekday.addAll(widget.preWeekday!);
      if (widget.preTime != null) selectedTime.addAll(widget.preTime!);
    });
    if (selectedNumberOfMembers != null) {
      numberMemberController.text =
          "$selectedNumberOfMembers ${S.current.txt_member}${selectedNumberOfMembers! > 1 ? "s" : ""}";
    }
    for (var type in selectedMatchType) {
      matchTypeController.text += "$type";
      if (type != selectedMatchType.last) {
        matchTypeController.text += "/";
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_appBar(), _buildBody()],
        ),
      ),
    );
  }

  _appBar() {
    return Container(
      height: _appBarHeight,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [BaseShadowStyle.appBar]),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              S.current.lbl_filter,
              style: BaseTextStyle.label(),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.transparent,
                      child: Text(
                        S.current.btn_cancel,
                        style: BaseTextStyle.body1(),
                      ),
                    )),
                GestureDetector(
                    onTap: () => apply(),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.transparent,
                      child: Text(
                        S.current.btn_apply,
                        style: BaseTextStyle.body1(color: BaseColor.green500),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: mediumPadding + smallPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget.title(title: S.current.lbl_level),
                  _rateBar(),
                  TextWidget.title(title: S.current.lbl_number_member),
                  TextFieldWidget.dropdown(
                      onTap: () => selectNumberOfMember(),
                      hintText: S.current.txt_number_member,
                      controller: numberMemberController,
                      isDirect: true,
                      context: context),
                  TextWidget.title(title: S.current.lbl_average_age),
                  Wrap(
                      direction: Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        ...[0, 16, 25, 35].map((age) => ChipWidget.filter(
                            content: AgeHelper.mapAgeToAges(age),
                            onTap: () => selectAge(age),
                            isSelected: selectedAverageAge.contains(age))),
                      ]),
                  TextWidget.title(title: S.current.lbl_needed_position),
                  Wrap(
                      direction: Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        ...Position.values.map((position) => ChipWidget.filter(
                            content: PositionHelper.mapKeyToTitle(position),
                            onTap: () => selectPosition(position),
                            isSelected: selectedPosition.contains(position))),
                      ]),
                  TextWidget.title(title: S.current.lbl_playing_area),
                  TextFieldWidget.dropdown(
                      onTap: () {},
                      hintText: S.current.txt_find_address,
                      context: context),
                  TextWidget.title(title: S.current.lbl_match_type),
                  TextFieldWidget.dropdown(
                      onTap: () => selectMatchType(),
                      hintText: S.current.txt_match_type,
                      controller: matchTypeController,
                      isDirect: true,
                      context: context),
                  TextWidget.title(title: S.current.lbl_playing_times),
                ],
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: mediumPadding + smallPadding),
                child: Row(
                  children: [
                    ...Weekday.values.map((weekday) => Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ChipWidget.filter(
                            content: WeekdayHelper.mapKeyToTitle(weekday),
                            onTap: () => selectWeekday(weekday),
                            isSelected: selectedWeekday.contains(weekday))))
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 32.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: mediumPadding + smallPadding),
                    child: Row(
                      children: [
                        ...[0, 6, 12, 18].map((time) => Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ChipWidget.filter(
                                content: TimeHelper.mapTimeToTimes(time),
                                onTap: () => selectTime(time),
                                isSelected: selectedTime.contains(time))))
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  _rateBar() {
    return Row(children: List.generate(5, (index) => _star(limit: index + 1)));
  }

  _star({required int limit}) {
    return GestureDetector(
        onTap: () {
          setState(() {
            currentRate = limit;
          });
        },
        child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: (currentRate ?? 0) >= limit
                ? BaseIcon.base(IconPath.starFill, color: BaseColor.yellow500)
                : BaseIcon.base(IconPath.starLine, color: BaseColor.grey300)));
  }

  void selectNumberOfMember() async {
    final result = await SheetWidget.base(
        context: context,
        body: SelectNumberOfMemberPage(
          preNumber: selectedNumberOfMembers,
        ));
    setState(() {
      selectedNumberOfMembers = result;
      numberMemberController.clear();
      if (selectedNumberOfMembers != null) {
        numberMemberController.text =
            "$selectedNumberOfMembers ${S.current.txt_member}${selectedNumberOfMembers! > 1 ? "s" : ""}";
      }
    });
  }

  void selectAge(int age) {
    setState(() {
      if (selectedAverageAge.contains(age)) {
        selectedAverageAge.remove(age);
      } else {
        selectedAverageAge.add(age);
      }
    });
  }

  void selectPosition(Position position) {
    setState(() {
      if (selectedPosition.contains(position)) {
        selectedPosition.remove(position);
      } else {
        selectedPosition.add(position);
      }
    });
  }

  void selectMatchType() async {
    final result = await SheetWidget.base(
        context: context,
        body: SelectMatchTypePage(
          preMatchTypes: selectedMatchType
              .map((e) => StadiumTypeHelper.mapIntToEnum(type: e))
              .toList(),
        ));
    setState(() {
      selectedMatchType.clear();
      selectedMatchType.addAll((result as List)
          .map((e) => StadiumTypeHelper.mapEnumToInt(stadiumType: e))
          .toList());
      matchTypeController.clear();
      if (selectedMatchType.isNotEmpty) {
        for (var type in selectedMatchType) {
          matchTypeController.text += "$type";
          if (type != selectedMatchType.last) {
            matchTypeController.text += "/";
          }
        }
      }
    });
  }

  void selectWeekday(Weekday weekday) {
    setState(() {
      if (selectedWeekday.contains(weekday)) {
        selectedWeekday.remove(weekday);
      } else {
        selectedWeekday.add(weekday);
      }
    });
  }

  void selectTime(int time) {
    setState(() {
      if (selectedTime.contains(time)) {
        selectedTime.remove(time);
      } else {
        selectedTime.add(time);
      }
    });
  }

  void apply() {
    Navigator.pop(context, [
      currentRate,
      selectedNumberOfMembers,
      selectedAverageAge,
      selectedPosition,
      "",
      selectedMatchType,
      selectedWeekday,
      selectedTime
    ]);
  }
}

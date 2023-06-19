import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/match/match.dart';
import 'package:minder/presentation/bloc/match/controller/match_controller_cubit.dart';
import 'package:minder/presentation/widget/match/time_option_widget.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/helper/time_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_text_style.dart';

class TimeChoiceWidget extends StatefulWidget {
  final TimeChoice timeChoice;
  final String matchId;
  final MatchTeam team;

  const TimeChoiceWidget(
      {Key? key,
      required this.timeChoice,
      required this.matchId,
      required this.team})
      : super(key: key);

  @override
  State<TimeChoiceWidget> createState() => _TimeChoiceWidgetState();
}

class _TimeChoiceWidgetState extends State<TimeChoiceWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              "${widget.timeChoice.displayDay!} (${TimeHelper.formatDate(widget.timeChoice.date.toString())})",
              style: BaseTextStyle.body1(color: BaseColor.green500),
            ),
          ),
          ...widget.timeChoice.options!.map((e) {
            return TimeOptionWidget.base(
                e,
                ((widget.team.selectedDayOfWeek ?? -1) ==
                        widget.timeChoice.dayOfWeek) &&
                    ((widget.team.from ?? -1) == e.from) &&
                    ((widget.team.to ?? -1) == e.to), () {
              _selectTime(
                  widget.matchId,
                  widget.timeChoice.date!,
                  widget.timeChoice.dayOfWeek!,
                  e,
                  widget.team.teamId!,
                  context);
            }, context);
          }).toList()
        ],
      ),
    );
  }

  void _selectTime(String matchId, DateTime date, num dayOfWeek,
      TimeOption timeOption, String teamId, BuildContext context) async {
    GetIt.instance.get<LoadingCoverController>().on(context);
    GetIt.instance
        .get<MatchControllerCubit>()
        .selectTime(matchId, date, dayOfWeek, timeOption, teamId)
        .then((value) =>
            GetIt.instance.get<LoadingCoverController>().off(context));
  }
}

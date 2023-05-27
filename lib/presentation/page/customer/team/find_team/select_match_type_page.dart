import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/enum/stadium_type_enum.dart';
import 'package:minder/util/helper/stadium_type_helper.dart';

class SelectMatchTypePage extends StatefulWidget {
  final List<StadiumType>? preMatchTypes;

  const SelectMatchTypePage({Key? key, this.preMatchTypes}) : super(key: key);

  @override
  State<SelectMatchTypePage> createState() => _SelectMatchTypePageState();
}

class _SelectMatchTypePageState extends State<SelectMatchTypePage> {
  List<StadiumType> selectedMatchTypes = List.empty(growable: true);

  @override
  void initState() {
    if (widget.preMatchTypes != null) {
      selectedMatchTypes.addAll(widget.preMatchTypes!);
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SheetWidget.title(
          context: context,
          title: S.current.lbl_match_type,
          submitContent: S.current.btn_done,
          onSubmit: () {
            Navigator.pop(context, selectedMatchTypes);
          }),
      Expanded(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 16, bottom: 32, left: 16, right: 16.0),
          child: Column(
            children: List.generate(StadiumType.values.length, (index) {
              final stadiumType = StadiumType.values[index];
              return TileWidget.checkbox(
                  title:
                      StadiumTypeHelper.mapEnumToInt(stadiumType: stadiumType)
                          .toString(),
                  isSelected: selectedMatchTypes.contains(stadiumType),
                  onChanged: (val) {
                    selectMatchType(stadiumType: stadiumType);
                  },
                  onTap: () => selectMatchType(stadiumType: stadiumType));
            }),
          ),
        ),
      ),
    ]);
  }

  void selectMatchType({required StadiumType stadiumType}) {
    setState(() {
      if (selectedMatchTypes.contains(stadiumType)) {
        selectedMatchTypes.remove(stadiumType);
      } else {
        selectedMatchTypes.add(stadiumType);
      }
      selectedMatchTypes.sort((a, b) => a.index.compareTo(b.index));
    });
  }
}

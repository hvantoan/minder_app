import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/enum/stadium_type_enum.dart';
import 'package:minder/util/helper/stadium_type_helper.dart';

class SelectStadiumTypePage extends StatefulWidget {
  final List<StadiumType> preStadiumType;

  const SelectStadiumTypePage({Key? key, required this.preStadiumType})
      : super(key: key);

  @override
  State<SelectStadiumTypePage> createState() => _SelectStadiumTypeState();
}

class _SelectStadiumTypeState extends State<SelectStadiumTypePage> {
  final List<StadiumType> selectedStadiumType = List.empty(growable: true);

  @override
  void initState() {
    setState(() {
      selectedStadiumType.addAll(widget.preStadiumType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SheetWidget.title(
          context: context,
          title: S.current.lbl_stadium_type,
          submitContent: S.current.btn_done,
          onSubmit: () {
            Navigator.pop(context, selectedStadiumType);
          }),
      Expanded(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 16, bottom: 32, left: 16, right: 16.0),
          child: Column(
            children: List.generate(StadiumType.values.length, (index) {
              final StadiumType type = StadiumType.values[index];
              return TileWidget.checkbox(
                  title:
                      "${S.current.lbl_stadium} ${StadiumTypeHelper.mapEnumToInt(stadiumType: type)}",
                  isSelected: selectedStadiumType.contains(type),
                  onChanged: (val) {
                    selectStadiumType(stadiumType: type);
                  },
                  onTap: () => selectStadiumType(stadiumType: type));
            }),
          ),
        ),
      ),
    ]);
  }

  void selectStadiumType({required StadiumType stadiumType}) {
    setState(() {
      if (!selectedStadiumType.contains(stadiumType)) {
        selectedStadiumType.add(stadiumType);
      } else {
        selectedStadiumType.remove(stadiumType);
      }
      selectedStadiumType.sort((a, b) => a.index.compareTo(b.index));
    });
  }
}

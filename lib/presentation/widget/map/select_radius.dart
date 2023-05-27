import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';

class SelectRadius extends StatefulWidget {
  final int? radius;

  const SelectRadius(this.radius, {Key? key}) : super(key: key);

  @override
  State<SelectRadius> createState() => _SelectRadiusState();
}

class _SelectRadiusState extends State<SelectRadius> {
  int? selectedRadius;
  final List<int> radiusList = [5, 10, 20, 50, 100];

  @override
  void initState() {
    setState(() {
      selectedRadius = widget.radius;
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
            Navigator.pop(context, selectedRadius);
          }),
      Expanded(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 16, bottom: 32, left: 16, right: 16.0),
          child: Column(
            children: List.generate(radiusList.length, (index) {
              return TileWidget.checkbox(
                  title: "${radiusList[index]} km",
                  isSelected: selectedRadius == radiusList[index],
                  onChanged: (val) {
                    selectRadius(radius: radiusList[index]);
                  },
                  onTap: () => selectRadius(radius: radiusList[index]));
            }),
          ),
        ),
      ),
    ]);
  }

  void selectRadius({required int radius}) {
    setState(() {
      selectedRadius = radius;
    });
    Navigator.pop(context, selectedRadius);
  }
}

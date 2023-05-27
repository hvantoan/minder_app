import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';

class SelectNumberOfMemberPage extends StatefulWidget {
  final int? preNumber;

  const SelectNumberOfMemberPage({Key? key, this.preNumber}) : super(key: key);

  @override
  State<SelectNumberOfMemberPage> createState() =>
      _SelectNumberOfMemberPageState();
}

class _SelectNumberOfMemberPageState extends State<SelectNumberOfMemberPage> {
  int? selectedNumber;

  @override
  void initState() {
    if (widget.preNumber != null) selectedNumber = widget.preNumber;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SheetWidget.title(
          context: context,
          title: S.current.lbl_number_member,
          submitContent: S.current.btn_done,
          onSubmit: () {
            Navigator.pop(context, selectedNumber);
          }),
      Expanded(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 16, bottom: 32, left: 16, right: 16.0),
          child: Column(
            children: List.generate(100, (index) {
              return TileWidget.checkbox(
                  title: "${index + 1}",
                  isSelected: selectedNumber == index + 1,
                  onChanged: (val) {
                    selectNumber(number: index + 1);
                  },
                  onTap: () => selectNumber(number: index + 1));
            }),
          ),
        ),
      ),
    ]);
  }

  void selectNumber({required int number}) {
    setState(() {
      if (selectedNumber == number) {
        selectedNumber = null;
      } else {
        selectedNumber = number;
      }
    });
  }
}

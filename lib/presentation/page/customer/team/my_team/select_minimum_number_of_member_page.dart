import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';

class SelectMinimumNOM extends StatefulWidget {
  final int? minNumberOfMember;

  const SelectMinimumNOM({Key? key, this.minNumberOfMember}) : super(key: key);

  @override
  State<SelectMinimumNOM> createState() => _SelectMinimumNOMState();
}

class _SelectMinimumNOMState extends State<SelectMinimumNOM> {
  int? selectedMinNOM;

  @override
  void initState() {
    selectedMinNOM = widget.minNumberOfMember;
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
            Navigator.pop(context, selectedMinNOM);
          }),
      Expanded(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 72, bottom: 32, left: 16, right: 16.0),
          child: Column(
            children: List.generate(5, (index) {
              return TileWidget.checkbox(
                  title:
                      "${index + 1} ${index > 0 ? S.current.txt_members : S.current.txt_member}",
                  isSelected: (index + 1) == selectedMinNOM,
                  onChanged: (val) {
                    selectMinNOM(min: index);
                  },
                  onTap: () => selectMinNOM(min: index));
            }),
          ),
        ),
      ),
    ]);
  }

  void selectMinNOM({required int min}) {
    setState(() {
      selectedMinNOM = min + 1;
    });
  }
}

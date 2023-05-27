import 'package:flutter/material.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';

class SelectItemsWidget extends StatefulWidget {
  final List<String> children;
  final String title;
  final bool? hasPadding;
  final List<String>? preList;
  final String? preItem;
  final bool isMulti;
  final ValueSetter<List<int>>? callbackList;
  final ValueSetter<int>? callbackItem;

  const SelectItemsWidget(
      {Key? key,
      required this.title,
      this.hasPadding,
      required this.children,
      this.preList,
      this.preItem,
      required this.isMulti,
      this.callbackList,
      this.callbackItem})
      : super(key: key);

  @override
  State<SelectItemsWidget> createState() => _SelectItemsWidgetState();
}

class _SelectItemsWidgetState extends State<SelectItemsWidget> {
  final List<int> selectedItems = List.empty(growable: true);
  int? selectedItem;
  bool selectAll = false;

  @override
  void initState() {
    setState(() {
      if (widget.isMulti) {
        if (widget.preList != null) {
          selectedItems
              .addAll(widget.preList!.map((e) => widget.children.indexOf(e)));
          if (selectedItems.length == widget.children.length) {
            selectAll = true;
          }
        }
      } else {
        if (widget.preItem != null) {
          selectedItem = widget.children.indexOf(widget.preItem!);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return aa();
  }

  aa() {
    return Column(
      children: [
        if (widget.isMulti)
          GestureDetector(
              onTap: () => selectAllItems(),
              child: TileWidget.checkbox(
                  title: "Select all",
                  isSelected: selectedItems.length == widget.children.length,
                  onChanged: (bool? value) {})),
        ...widget.children.map((e) {
          if (widget.isMulti) {
            return TileWidget.checkbox(
              onTap: () => selectItems(item: e),
              title: e,
              isSelected: selectedItems.contains(widget.children.indexOf(e)),
              onChanged: (bool? value) {},
            );
          }
          return const SizedBox.shrink();
        })
      ],
    );
  }

  void selectItems({required String item}) {
    final index = widget.children.indexOf(item);
    setState(() {
      if (!selectedItems.contains(index)) {
        selectedItems.add(index);
        if (selectedItems.length == widget.children.length) {
          selectAll = true;
        }
      } else {
        selectAll = false;
        selectedItems.remove(index);
      }
    });
    widget.callbackList!(selectedItems);
  }

  void selectAllItems() {
    setState(() {
      selectAll = !selectAll;
      selectedItems.clear();
      if (selectAll) {
        selectedItems
            .addAll(widget.children.map((e) => widget.children.indexOf(e)));
      }
    });

    widget.callbackList!(selectedItems);
  }

  void selectItem({required String item}) {
    setState(() {
      selectedItem = widget.children.indexOf(item);
    });

    widget.callbackItem!(selectedItem!);
  }
}

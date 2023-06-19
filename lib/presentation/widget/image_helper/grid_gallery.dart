import 'package:flutter/material.dart';
import 'package:minder/presentation/widget/checkbox/checkbox_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

class GridGallery extends StatefulWidget {
  const GridGallery({super.key, this.scrollCtr, required this.onChange});
  final Function(Uint8List?) onChange;
  final ScrollController? scrollCtr;

  @override
  State<GridGallery> createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  final List<Uint8List> _mediaList = [];

  int currentPage = 0;
  int selectedIndex = -1;
  int? lastPage;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media = await albums[0]
          .getAssetListPaged(size: 10, page: currentPage); //preloading files
      List<Uint8List> temps = [];
      for (var asset in media) {
        if (asset.type == AssetType.image) {
          var file =
              await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));
          temps.add(file!);
        }
      }
      setState(() {
        _mediaList.addAll(temps);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  _onSlectedFile(Uint8List file, int index) {
    if (selectedIndex == index) {
      widget.onChange(null);
      selectedIndex = -1;
    } else {
      widget.onChange(file);
      selectedIndex = index;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return false;
      },
      child: GridView.builder(
        controller: widget.scrollCtr,
        itemCount: _mediaList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
        itemBuilder: (BuildContext context, int index) {
          var file = _mediaList[index];
          return SizedBox(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.memory(
                    file,
                    fit: BoxFit.cover,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onSlectedFile(file, index);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        child: selectedIndex == index
                            ? CheckBoxWidget.base(
                                currentValue: true,
                                onChanged: (value) {
                                  _onSlectedFile(file, index);
                                },
                              )
                            : Container(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

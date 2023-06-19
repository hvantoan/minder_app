import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:minder/domain/entity/stadium/stadium.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/stadium/data/stadiums/stadiums_cubit.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/shimmer/shimmer_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/helper/location_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';
import 'package:tiengviet/tiengviet.dart';

class SelectStadiumPage extends StatefulWidget {
  final Stadium? stadium;
  final LatLng latLng;
  final String matchId;

  const SelectStadiumPage({
    Key? key,
    this.stadium,
    required this.latLng,
    required this.matchId,
  }) : super(key: key);

  @override
  State<SelectStadiumPage> createState() => _SelectStadiumPageState();
}

class _SelectStadiumPageState extends State<SelectStadiumPage> {
  Stadium? stadium;
  String currentSearchString = "";

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    setState(() {
      stadium = widget.stadium;
    });
    GetIt.instance.get<StadiumsCubit>().clean();
    GetIt.instance
        .get<StadiumsCubit>()
        .getStadiumSuggest(matchId: widget.matchId);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SheetWidget.title(
            context: context,
            title: S.current.lbl_select_stadium,
            submitContent: S.current.btn_done,
            rollbackContent: S.current.btn_cancel,
            onSubmit: () => Navigator.pop(context, stadium?.id)),
        _buildBody()
      ],
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 24, bottom: 12.0, left: 16.0, right: 16.0),
            child: TextFieldWidget.search(
                onChanged: (text) {
                  setState(() {
                    currentSearchString = text;
                  });
                },
                textEditingController: searchController,
                onSuffixIconTap: () {
                  setState(() {
                    searchController.clear();
                    currentSearchString = "";
                  });
                  FocusScope.of(context).unfocus();
                }),
          ),
          Expanded(
            child: BlocBuilder<StadiumsCubit, StadiumsState>(
              builder: (context, state) {
                if (state is StadiumsSuccess) {
                  var stadiums = filterStadiums(state.stadiums);
                  if (stadiums.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: stadiums.length,
                        itemBuilder: (context, index) {
                          final stadium = stadiums[index];
                          return TileWidget.checkbox(
                            title: stadium.name!,
                            isSelected: stadium.id == this.stadium?.id,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Row(
                                    children: [
                                      BaseIcon.base(IconPath.locationLine,
                                          size: const Size(16, 12),
                                          color: BaseColor.green500),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                          "${NumberFormat("###,###.##").format(LocationHelper.distance(widget.latLng, LatLng(stadium.latitude!, stadium.longitude!)))} km",
                                          style: BaseTextStyle.body2(
                                              color: BaseColor.grey500)),
                                    ],
                                  ),
                                ),
                                Text(stadium.fullAddress!,
                                    style: BaseTextStyle.body2(
                                        color: BaseColor.grey500)),
                              ],
                            ),
                            onChanged: (value) => selectStadium(stadium),
                            onTap: () => selectStadium(stadium),
                          );
                        });
                  } else {
                    return Center(
                      child: Text(
                        S.current.txt_no_suitable_stadium,
                        style: BaseTextStyle.body1(),
                      ),
                    );
                  }
                }
                return _shimmer();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _shimmer() {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0, top: 12),
            child: ShimmerWidget.base(
                borderRadius: BorderRadius.circular(12.0),
                width: double.infinity,
                height: 80),
          );
        });
  }

  List<Stadium> filterStadiums(List<Stadium> originStadiums) {
    var stadiums = originStadiums
        .where((element) => TiengViet.parse(element.name!)
            .toLowerCase()
            .contains(
                TiengViet.parse(currentSearchString).toLowerCase().trim()))
        .toList();
    stadiums.addAll(originStadiums.where((element) =>
        TiengViet.parse(element.fullAddress!).toLowerCase().contains(
            TiengViet.parse(currentSearchString).toLowerCase().trim())));
    stadiums.sort((a, b) {
      final firstDistance = LocationHelper.distance(
          widget.latLng, LatLng(a.latitude!, a.longitude!));
      final secondDistance = LocationHelper.distance(
          widget.latLng, LatLng(b.latitude!, b.longitude!));
      return firstDistance.compareTo(secondDistance);
    });
    return stadiums.toSet().toList();
  }

  void selectStadium(Stadium stadium) {
    setState(() {
      if (this.stadium?.id == stadium.id) {
        this.stadium = null;
      } else {
        this.stadium = stadium;
      }
    });
  }
}

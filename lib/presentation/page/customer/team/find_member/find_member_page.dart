import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/data/find_member/find_member_cubit.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/page/customer/team/find_member/recommend_player_page.dart';
import 'package:minder/presentation/page/customer/team/find_member/request_join_page.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/player/player_tile_widget.dart';
import 'package:minder/presentation/widget/shimmer/shimmer_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/presentation/widget/tile/list_tile_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/helper/location_helper.dart';
import 'package:minder/util/helper/string_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';
import 'package:tiengviet/tiengviet.dart';

const int _shimmerAmount = 5;

class FindMemberPage extends StatefulWidget {
  final Team team;
  final bool isScroll;

  const FindMemberPage({Key? key, required this.team, required this.isScroll})
      : super(key: key);

  @override
  State<FindMemberPage> createState() => _FindMemberPageState();
}

class _FindMemberPageState extends State<FindMemberPage> {
  bool onSearch = false;
  String currentSearchString = "";

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    GetIt.instance.get<FindMemberCubit>().clean();
    GetIt.instance.get<FindMemberCubit>().getData(teamId: widget.team.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: widget.isScroll
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
          horizontal: mediumPadding + smallPadding, vertical: largePadding),
      child: BlocBuilder<FindMemberCubit, FindMemberState>(
          builder: (context, state) {
        if (state is FindMemberSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldWidget.search(
                  onChanged: (text) {
                    setState(() {
                      currentSearchString = text;
                    });
                  },
                  focusNode: searchFocusNode,
                  textEditingController: searchController,
                  onSuffixIconTap: () => clearSearch()),
              if (state.invites.isNotEmpty)
                ListTileWidget.base(
                  title: S.current.lbl_want_to_join,
                  textEmpty: S.current.txt_no_player,
                  children: List.generate(
                      filterUser(state.invites.map((e) => e.user!).toList())
                          .length, (index) {
                    final user = filterUser(
                        state.invites.map((e) => e.user!).toList())[index];
                    return PlayerTileWidget.base(
                      user: user,
                      subtitle: Text(
                        StringHelper.calculateAge(user.dayOfBirth),
                        style: BaseTextStyle.body2(color: BaseColor.grey500),
                      ),
                      onTap: () {
                        final invites = state.invites;
                        final invite = invites
                            .firstWhere((element) => element.userId == user.id);
                        invites.remove(invite);
                        invites.insert(0, invite);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestJoinPage(
                              invites: invites,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ListTileWidget.base(
                title: S.current.lbl_players_near_you,
                textEmpty: S.current.txt_no_player,
                children:
                    List.generate(filterUser(state.allUsers).length, (index) {
                  final user = filterUser(state.allUsers)[index];
                  return PlayerTileWidget.base(
                    user: user,
                    subtitle: Row(
                      children: [
                        BaseIcon.base(IconPath.locationLine,
                            color: BaseColor.grey500, size: const Size(16, 16)),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "${NumberFormat('#,###,###.##').format(LocationHelper.distance(LatLng(widget.team.gameSetting!.latitude!.toDouble(), widget.team.gameSetting!.longitude!.toDouble()), LatLng(user.gameSetting!.latitude!.toDouble(), user.gameSetting!.longitude!.toDouble())))} km",
                            style:
                                BaseTextStyle.body2(color: BaseColor.grey500),
                          ),
                        )
                      ],
                    ),
                    onTap: () async {
                      final users = filterUser(state.allUsers);
                      users.remove(user);
                      users.insert(0, user);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecommendPlayerPage(
                                    users: users,
                                    teamId: widget.team.id,
                                  )));
                    },
                  );
                }),
              ),
            ],
          );
        }
        if (state is FindMemberFailure) {
          return ExceptionWidget(
            subContent: state.message,
            imagePath: ImagePath.dataParsingFailed,
            buttonContent: S.current.btn_try_again,
            onButtonTap: () => GetIt.instance
                .get<FindMemberCubit>()
                .getData(teamId: widget.team.id),
          );
        }
        return _shimmer();
      }),
    );
  }

  Widget _shimmer() {
    return Column(
      children: [
        ShimmerWidget.base(
            width: double.infinity,
            height: 48.0,
            borderRadius: BorderRadius.circular(16.0)),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ShimmerWidget.base(
              width: double.infinity,
              height: 24.0,
              borderRadius: BorderRadius.circular(16.0)),
        ),
        ...List.generate(_shimmerAmount, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ShimmerWidget.base(
                width: double.infinity,
                height: playerTileHeight,
                borderRadius: BorderRadius.circular(16.0)),
          );
        }),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ShimmerWidget.base(
              width: double.infinity,
              height: 24.0,
              borderRadius: BorderRadius.circular(16.0)),
        ),
        ...List.generate(_shimmerAmount, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ShimmerWidget.base(
                width: double.infinity,
                height: playerTileHeight,
                borderRadius: BorderRadius.circular(16.0)),
          );
        })
      ],
    );
  }

  void clearSearch() => setState(() {
        onSearch = false;
        searchController.clear();
        currentSearchString = "";
        searchFocusNode.unfocus();
      });

  List<User> filterUser(List<User> users) {
    return users
        .where((user) => TiengViet.parse(user.name.toString())
            .toLowerCase()
            .contains(TiengViet.parse(currentSearchString).toLowerCase()))
        .toList();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/shimmer/shimmer_widget.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/util/constant/enum/gender_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/helper/gender_helper.dart';
import 'package:minder/util/helper/position_helper.dart';
import 'package:minder/util/helper/string_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

const double _coverHeight = 136.0;
const double _appBarHeight = 56.0;
const double _headerHeight = 225;

class MemberProfilePage extends StatefulWidget {
  final Member me;
  final Member member;

  const MemberProfilePage({Key? key, required this.me, required this.member})
      : super(key: key);

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage> {
  final ScrollController scrollController = ScrollController();
  bool isScroll = false;

  @override
  void initState() {
    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is TeamControllerErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.danger(
            context: context, title: event.message, isClosable: false));
        return;
      }
      if (event is TeamControllerSuccessState) {
        GetIt.instance.get<TeamControllerCubit>().clear();
        Navigator.pop(context);
      }
    });
    GetIt.instance.get<UserCubit>().clean();
    scrollController.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          bloc: GetIt.instance.get<UserCubit>()
            ..getUser(me: widget.me.user!, uid: widget.member.userId),
          builder: (context, state) {
            if (state is UserSuccess) {
              if (state.other != null) {
                return CustomScrollView(
                  controller: scrollController,
                  shrinkWrap: true,
                  slivers: [
                    buildHeader(user: state.other!),
                    buildBody(user: state.other!),
                  ],
                );
              }
              return ExceptionWidget(
                subContent: S.current.txt_data_parsing_failed,
                imagePath: ImagePath.dataParsingFailed,
                buttonContent: S.current.btn_try_again,
                onButtonTap: () => GetIt.instance
                    .get<UserCubit>()
                    .getUser(me: widget.me.user!, uid: widget.member.userId),
              );
            }
            if (state is UserError) {
              return ExceptionWidget(
                  subContent: S.current.txt_data_parsing_failed,
                  imagePath: ImagePath.dataParsingFailed,
                  buttonContent: S.current.btn_try_again,
                  onButtonTap: () => GetIt.instance
                      .get<UserCubit>()
                      .getUser(me: widget.me.user!, uid: widget.member.userId));
            }
            return _shimmer();
          },
        ),
      ),
    );
  }

  Widget buildHeader({required User user}) {
    return SliverAppBar(
        backgroundColor: Colors.white,
        expandedHeight: _headerHeight,
        pinned: true,
        elevation: 0,
        titleSpacing: 0,
        title: isScroll
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AvatarWidget.base(
                        name: user.name ?? "",
                        imagePath: null,
                        size: smallAvatarSize),
                  ),
                  Text("${user.name} ", style: BaseTextStyle.label()),
                ],
              )
            : null,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: BaseIcon.base(IconPath.arrowLeftLine,
                color: isScroll ? null : Colors.white)),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          titlePadding: EdgeInsets.zero,
          title: !isScroll
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${user.name} ", style: BaseTextStyle.label()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "${GenderHelper.mapKeyToName(user.sex ?? Gender.different)} - ${StringHelper.calculateAge(user.dayOfBirth)}",
                            style: BaseTextStyle.body2()),
                      ],
                    ),
                  ],
                )
              : null,
          expandedTitleScale: 1.0,
          background: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: _coverHeight,
                child: user.cover != null
                    ? Image.network(
                        user.cover!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        ImagePath.defaultCover,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                  top: _coverHeight - largeAvatarSize / 2,
                  left:
                      (MediaQuery.of(context).size.width - largeAvatarSize) / 2,
                  child: AvatarWidget.base(
                      name: user.name ?? "", imagePath: null, isBorder: true)),
            ],
          ),
        ));
  }

  Widget buildBody({required User user}) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget.title(title: S.current.lbl_description),
            Text(
              user.description ?? S.current.txt_no_description,
              style: BaseTextStyle.body1(),
            ),
            TextWidget.title(title: S.current.lbl_playing_position),
            (user.gameSetting!.positions != null &&
                    user.gameSetting!.positions!.isNotEmpty)
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: user.gameSetting!.positions!
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: PositionHelper.mapKeyToChip(e),
                              ))
                          .toList(),
                    ),
                  )
                : Text(
                    S.current.txt_no_position,
                    style: BaseTextStyle.body1(),
                  ),
            TextWidget.title(title: S.current.lbl_level),
            _rateBar(level: user.gameSetting!.rank!.toInt()),
            TextWidget.title(title: S.current.lbl_number_of_matches),
            TextWidget.title(title: S.current.lbl_phone_number),
            Text(
              user.phone ?? S.current.txt_no_phone_number,
              style: BaseTextStyle.body1(),
            ),
            TextWidget.title(title: S.current.lbl_email),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                user.username ?? S.current.txt_no_email,
                style: BaseTextStyle.body1(),
              ),
            ),
            if (widget.member.id != widget.me.id &&
                widget.member.regency != 2 &&
                widget.me.regency == 2)
              ButtonWidget.out(
                  onTap: () {
                    kick();
                  },
                  hasBackgroundColor: false,
                  content: S.current.btn_remove_from_team,
                  suffixIconPath: IconPath.deleteLine),
          ],
        ),
      ),
    );
  }

  Widget _shimmer() {
    final pageWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: _headerHeight,
          child: Stack(
            children: [
              ShimmerWidget.base(width: double.infinity, height: _coverHeight),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: BaseIcon.base(IconPath.arrowLeftLine)),
              ),
              Positioned(
                  top: _coverHeight - largeAvatarSize / 2,
                  left: (pageWidth - 88) / 2,
                  child: Container(
                      padding:
                          EdgeInsets.all((largeAvatarSize ~/ 30).toDouble()),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: BaseColor.green400)),
                      child: ShimmerWidget.base(
                          width: largeAvatarSize,
                          height: largeAvatarSize,
                          shape: BoxShape.circle))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShimmerWidget.base(
                        width: 100,
                        height: 20.0,
                        borderRadius: BorderRadius.circular(16.0)),
                    ShimmerWidget.base(
                        width: 100,
                        height: 20.0,
                        borderRadius: BorderRadius.circular(16.0)),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: ShimmerWidget.base(
                    width: pageWidth / 2,
                    height: 24,
                    borderRadius: BorderRadius.circular(16.0)),
              ),
              ShimmerWidget.base(
                  width: pageWidth,
                  height: 24,
                  borderRadius: BorderRadius.circular(16.0)),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: ShimmerWidget.base(
                    width: pageWidth / 2,
                    height: 24,
                    borderRadius: BorderRadius.circular(16.0)),
              ),
              ShimmerWidget.base(
                  width: pageWidth,
                  height: 24,
                  borderRadius: BorderRadius.circular(16.0)),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: ShimmerWidget.base(
                    width: pageWidth / 2,
                    height: 24,
                    borderRadius: BorderRadius.circular(16.0)),
              ),
              _rateBar(level: 0),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: ShimmerWidget.base(
                    width: pageWidth / 2,
                    height: 24,
                    borderRadius: BorderRadius.circular(16.0)),
              ),
              ShimmerWidget.base(
                  width: pageWidth,
                  height: 24,
                  borderRadius: BorderRadius.circular(16.0)),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: ShimmerWidget.base(
                    width: pageWidth / 2,
                    height: 24,
                    borderRadius: BorderRadius.circular(16.0)),
              ),
              ShimmerWidget.base(
                  width: pageWidth,
                  height: 24,
                  borderRadius: BorderRadius.circular(16.0)),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: ShimmerWidget.base(
                    width: pageWidth / 2,
                    height: 24,
                    borderRadius: BorderRadius.circular(16.0)),
              ),
              ShimmerWidget.base(
                  width: pageWidth,
                  height: 24,
                  borderRadius: BorderRadius.circular(16.0)),
            ]))
      ]),
    );
  }

  _rateBar({required int level}) {
    return Row(
        children:
            List.generate(5, (index) => _star(limit: index + 1, level: level)));
  }

  _star({required int limit, required int level}) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: level >= limit
            ? BaseIcon.base(IconPath.starFill, color: BaseColor.yellow500)
            : BaseIcon.base(IconPath.starLine, color: BaseColor.grey300));
  }

  void _onScrollEvent() {
    final pixels = scrollController.position.pixels;
    if (pixels > _appBarHeight * 2) {
      setState(() {
        isScroll = true;
      });
    } else {
      setState(() {
        isScroll = false;
      });
    }
  }

  void kick() => GetIt.instance
      .get<TeamControllerCubit>()
      .kick(userId: widget.member.userId);
}

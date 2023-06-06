import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/group/group.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/data/team/team_cubit.dart';
import 'package:minder/presentation/page/customer/team/chat_page.dart';
import 'package:minder/presentation/page/customer/team/find_member/find_member_page.dart';
import 'package:minder/presentation/page/customer/team/match/match_team_page.dart';
import 'package:minder/presentation/page/customer/team/my_team/team_setting_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/chat/chat_input.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/shimmer/shimmer_widget.dart';
import 'package:minder/presentation/widget/tab/tab_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

const double _coverHeight = 136.0;
const double _appBarHeight = 56.0;
const double _tabBarHeight = 40.0;
const double _headerHeight = 252;

class TeamDetailPage extends StatefulWidget {
  final String teamId;
  final int regency;

  const TeamDetailPage({Key? key, required this.teamId, required this.regency})
      : super(key: key);

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  final ScrollController scrollController = ScrollController();
  int _pageIndex = 0;
  bool _displayChatInput = true;
  bool isScroll = false;
  String _groupId = "";

  @override
  void initState() {
    GetIt.instance.get<TeamCubit>().clean();
    GetIt.instance.get<TeamCubit>().getTeamById(teamId: widget.teamId);
    scrollController.addListener(_onScrollEvent);
    GetIt.instance.get<TeamCubit>().stream.listen((event) {
      if (!mounted) return;
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _displayChatInput = _pageIndex == 1;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:
          _displayChatInput ? ChatInput(groupId: _groupId) : null,
      body: SafeArea(
        child: BlocBuilder<TeamCubit, TeamState>(
          bloc: GetIt.instance.get<TeamCubit>(),
          builder: (context, state) {
            if (state is TeamErrorState) {
              return buildException(message: state.message);
            }
            if (state is TeamSuccessState) {
              _groupId = state.team.groupId ?? "";
              return DefaultTabController(
                  length: widget.regency > 0 ? 3 : 2,
                  child: CustomScrollView(
                    controller: scrollController,
                    shrinkWrap: true,
                    slivers: [
                      buildHeader(team: state.team),
                      buildBody(children: [
                        MatchTeamPage(
                          regency: widget.regency,
                          team: state.team,
                          isScroll: isScroll,
                        ),
                        TeamChatPage(
                          appBarDisplay: false,
                          group: Group(
                            id: "",
                            title: state.team.name,
                            chanelId: state.team.id,
                            lastMessage: "",
                            createAt: DateTime.now(),
                            type: 0,
                            displayType: "",
                            online: true,
                          ),
                          height: (isScroll ? 0 : _headerHeight),
                        ),
                        if (widget.regency > 0)
                          FindMemberPage(
                            team: state.team,
                            isScroll: isScroll,
                          )
                      ]),
                    ],
                  ));
            }
            return _shimmer();
          },
        ),
      ),
    );
  }

  Widget buildHeader({required Team team}) {
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
                        name: team.name,
                        imagePath: team.avatar,
                        size: smallAvatarSize),
                  ),
                  Expanded(
                    child: Text(
                      "${team.name}(${team.code})",
                      style: BaseTextStyle.label(),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              )
            : null,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: BaseIcon.base(IconPath.arrowLeftLine,
                color: isScroll ? null : Colors.white)),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          title: !isScroll
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${team.name} ", style: BaseTextStyle.label()),
                    Text(" (${team.code})", style: BaseTextStyle.body1()),
                  ],
                )
              : null,
          titlePadding: const EdgeInsets.only(bottom: _tabBarHeight),
          expandedTitleScale: 1.0,
          background: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: _coverHeight,
                child: team.cover != null
                    ? Image.network(
                        team.cover!,
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
                      name: team.name, imagePath: team.avatar, isBorder: true)),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamSettingPage(team: team))),
              icon: BaseIcon.base(IconPath.settingsLine,
                  color: isScroll ? null : Colors.white))
        ],
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, _tabBarHeight),
            child: Container(
              height: _tabBarHeight,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: BaseColor.grey200))),
              child: TabBar(
                  labelStyle: BaseTextStyle.label(),
                  labelColor: BaseColor.green500,
                  unselectedLabelColor: BaseColor.grey500,
                  unselectedLabelStyle: BaseTextStyle.body1(),
                  indicatorColor: BaseColor.green500,
                  onTap: (value) => setState(() => _pageIndex = value),
                  tabs: [
                    TabWidget.base(
                      text: S.current.lbl_match,
                    ),
                    TabWidget.base(
                      text: S.current.lbl_conversation,
                    ),
                    if (widget.regency > 0)
                      TabWidget.base(
                        text: S.current.lbl_find_member,
                      ),
                  ]),
            )));
  }

  Widget buildException({required String message}) {
    return ExceptionWidget(
      subContent: message,
      imagePath: ImagePath.dataParsingFailed,
      buttonContent: S.current.btn_back,
      onButtonTap: () => Navigator.pop(context),
    );
  }

  Widget buildBody({required List<Widget> children}) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            _tabBarHeight -
            _appBarHeight -
            24,
        child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(children.length, (index) {
              return children[index];
            })),
      ),
    );
  }

  Widget _shimmer() {
    final pageWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: _headerHeight - _tabBarHeight,
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
                child: ShimmerWidget.base(
                    width: 100,
                    height: 24.0,
                    borderRadius: BorderRadius.circular(16.0)),
              )
            ],
          ),
        ),
        Container(
            height: _tabBarHeight,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8.0),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: BaseColor.grey200))),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ShimmerWidget.base(
                      width: pageWidth,
                      height: 24.0,
                      borderRadius: BorderRadius.circular(16.0)),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ShimmerWidget.base(
                      width: pageWidth,
                      height: 24.0,
                      borderRadius: BorderRadius.circular(16.0)),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ShimmerWidget.base(
                      width: pageWidth,
                      height: 24.0,
                      borderRadius: BorderRadius.circular(16.0)),
                )),
              ],
            ))
      ],
    );
  }

  void _onScrollEvent() {
    final pixels = scrollController.position.pixels;
    if (pixels > _tabBarHeight + _appBarHeight) {
      setState(() {
        isScroll = true;
      });
    } else {
      setState(() {
        isScroll = false;
      });
    }
  }
}

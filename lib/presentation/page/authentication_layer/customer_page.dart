import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/presentation/bloc/base_layer/base_layer_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/common/notification/notification_page.dart';
import 'package:minder/presentation/page/customer/home/personal_home_page.dart';
import 'package:minder/presentation/page/customer/settings/personal_settings_page.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/widget/bottom_navigation/customer_bottom_navigation.dart';

const String _filePath =
    "lib/presentation/page/authentication_layer/customer_page.dart";

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = 0;
    GetIt.instance.get<UserCubit>().getMe();
    GetIt.instance.get<BaseLayerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is LanguageState) {
        setState(() {});
        return;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(filePath: _filePath, widget: "Staff Page");
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                PersonalHomePage(),
                AllTeamPage(),
                NotificationPage(),
                PersonalSettingsPage(),
              ]),
          CustomerBottomNavigation(
              currentIndex: _tabController.index,
              onIndexChange: (newIndex) =>
                  setState(() => _tabController.index = newIndex)),
        ],
      ),
    );
  }
}

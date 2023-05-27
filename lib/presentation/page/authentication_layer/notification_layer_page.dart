import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/debug/debug_helper.dart';
import 'package:minder/presentation/bloc/group/group_cubit.dart';
import 'package:minder/presentation/bloc/notification_layer/notification_layer_cubit.dart';
import 'package:minder/presentation/page/app_layer/app_loading_page.dart';
import 'package:minder/presentation/page/authentication_layer/customer_page.dart';
import 'package:signalr_netcore/signalr_client.dart';

const String _filePath =
    "lib/presentation/page/authentication_layer/notification_layer_pagedart";

class NotificationLayerPage extends StatefulWidget {
  const NotificationLayerPage({super.key});

  @override
  State<NotificationLayerPage> createState() => _NotificationLayerPageState();
}

class _NotificationLayerPageState extends State<NotificationLayerPage> {
  late HubConnection _hub;

  @override
  void initState() {
    GetIt.instance.get<NotificationLayerCubit>().connectionHub(context);
    super.initState();
  }

  @override
  void dispose() {
    _hub.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(
        filePath: _filePath, widget: "Notification Layer Page");
    return BlocConsumer<NotificationLayerCubit, NotificationLayerState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ConnectedState) {
          _hub = state.hub;
          GetIt.instance.get<GroupCubit>().load(pageIndex: 0, pageSize: 10);
          return const CustomerPage();
        }
        return const AppLoadingPage();
      },
    );
  }
}

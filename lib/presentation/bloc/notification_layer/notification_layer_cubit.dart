import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/presentation/bloc/group/group_cubit.dart';
import 'package:minder/presentation/bloc/message/message_cubit.dart';
import 'package:minder/util/constant/path/service_path.dart';
import 'package:minder/util/helper/token_helper.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
part 'notification_layer_state.dart';

class NotificationLayerCubit extends Cubit<NotificationLayerState> {
  NotificationLayerCubit() : super(NotificationLayerInitial());

  connectionHub(BuildContext context) async {
    String? token;

    bool isValidToken = await TokenHelper.checkToken();
    if (isValidToken) token = await TokenHelper.getAccessToken();

    final httpConnectionOptions = HttpConnectionOptions(
      transport: HttpTransportType.WebSockets,
      logMessageContent: false,
    );

    final hub = HubConnectionBuilder()
        .withUrl("${ServicePath.hub}?access_token=$token",
            options: httpConnectionOptions)
        .withHubProtocol(JsonHubProtocol())
        .build();
    hub.on(
      "RecieveMessage",
      (arguments) {
        GetIt.instance.get<MessageCubit>().emitState();
      },
    );
    hub.on(
      "ReloadGroup",
      (arguments) {
        GetIt.instance.get<GroupCubit>().load(pageIndex: 0, pageSize: 100);
      },
    );
    await hub.start();

    if (hub.state == HubConnectionState.Connected) {
      emit(ConnectedState(hub: hub));
    } else {
      emit(NotificationLayerErrorState());
    }
  }
}

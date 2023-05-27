import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/widget/player/player_card_widget.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_shadow_style.dart';
import 'package:minder/util/style/base_text_style.dart';

class SwipeUserPage extends StatefulWidget {
  final List<User> users;
  final Function(User user) cancel;
  final Function(User user) confirm;
  final bool isRequest;

  const SwipeUserPage(
      {Key? key,
      required this.users,
      required this.cancel,
      required this.confirm,
      required this.isRequest})
      : super(key: key);

  @override
  State<SwipeUserPage> createState() => _SwipeUserPageState();
}

class _SwipeUserPageState extends State<SwipeUserPage> {
  double angle = 0;
  Offset position = Offset.zero;
  bool isDragging = false;
  final double limitDegree = 30.0;
  double cancelRatio = 0.0;
  double confirmRatio = 0.0;
  final List<Widget> cards = List.empty(growable: true);
  final List<User> users = List.empty(growable: true);

  @override
  void initState() {
    setState(() {
      users.addAll(widget.users);
      cards.addAll(users.map((user) => PlayerCardWidget.card(user)));
    });
    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is TeamControllerErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.danger(
            context: context, title: event.message, isClosable: false));
        return;
      }
      if (event is TeamControllerSuccessState) {
        GetIt.instance.get<TeamControllerCubit>().clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return cards.isNotEmpty
        ? Stack(
            children: List.generate(cards.length, (index) {
              final card = cards[index];
              final user = users[index];
              if (index == cards.length - 1) {
                return Stack(
                  children: [
                    _swipeCard(child: card, user: user),
                    _buttonArea(index: index),
                  ],
                );
              }
              return card;
            }),
          )
        : Center(
            child: Text(S.current.txt_no_player, style: BaseTextStyle.body1()));
  }

  Widget _swipeCard({required Widget child, required User user}) {
    return SizedBox.expand(
      child: GestureDetector(
        onHorizontalDragStart: (details) => _start(details),
        onHorizontalDragUpdate: (details) => _update(details),
        onHorizontalDragEnd: (details) => _end(details, child, user),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int milliseconds = isDragging ? 0 : 0;
            final center = constraints.smallest.center(Offset.zero);
            final rotateMatrix4 = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle / 180)
              ..translate(-center.dx, -center.dy);
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;
            return AnimatedContainer(
              duration: Duration(milliseconds: milliseconds),
              curve: Curves.easeInOut,
              transform: rotateMatrix4..translate(position.dx, position.dy),
              child: Stack(
                children: [
                  child,
                  if (confirmRatio > 0)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: width,
                        height: height,
                        color: BaseColor.green500.withOpacity(confirmRatio),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buttonArea({required index}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.bottom + 32.0,
            horizontal: 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                for (int i = 0; i < limitDegree * 2; i++) {
                  await Future.delayed(const Duration(milliseconds: 5), () {
                    setState(() {
                      position += const Offset(-5, 0);
                      angle = (limitDegree *
                              position.dx /
                              MediaQuery.of(context).size.width) *
                          pi;
                      double ratio = angle.abs() / (limitDegree * 2);
                      cancelRatio = ratio > 1 ? 1 : ratio;
                    });
                  });
                  if (cancelRatio == 1) {
                    widget.cancel.call(users[index]);
                    cards.removeAt(index);
                    users.removeAt(index);
                    cancelRatio = 0;
                    position = Offset.zero;
                    angle = 0.0;
                    break;
                  }
                }
              },
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    boxShadow: [BaseShadowStyle.common],
                    shape: BoxShape.circle,
                    color: Colors.white),
                child: BaseIcon.base(
                  IconPath.xLine,
                  color: BaseColor.green500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                for (int i = 0; i < limitDegree * 2; i++) {
                  await Future.delayed(const Duration(milliseconds: 5), () {
                    setState(() {
                      position += const Offset(5, 0);
                      angle = (limitDegree *
                              position.dx /
                              MediaQuery.of(context).size.width) *
                          pi;
                      double ratio = angle.abs() / (limitDegree * 2);
                      confirmRatio = ratio > 1 ? 1 : ratio;
                    });
                  });
                  if (confirmRatio == 1) {
                    widget.confirm.call(users[index]);
                    cards.removeAt(index);
                    users.removeAt(index);
                    confirmRatio = 0;
                    position = Offset.zero;
                    angle = 0.0;
                    break;
                  }
                }
              },
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: BaseColor.green500),
                child: BaseIcon.base(
                  IconPath.confirmBold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _start(DragStartDetails details) => setState(() {
        isDragging = true;
      });

  void _update(DragUpdateDetails details) => setState(() {
        position += details.delta;
        angle =
            (limitDegree * position.dx / MediaQuery.of(context).size.width) *
                pi;
        double ratio = angle.abs() / (limitDegree * 2);
        if (angle < 0) {
          cancelRatio = ratio > 1 ? 1 : ratio;
        } else {
          confirmRatio = ratio > 1 ? 1 : ratio;
        }
      });

  void _end(DragEndDetails details, Widget child, User user) => setState(() {
        if (angle > limitDegree * 2 || angle < -limitDegree * 2) {
          cards.remove(child);
          users.remove(user);
          if (angle > limitDegree * 2) {
            widget.confirm.call(user);
          }
          if (angle < -limitDegree * 2) {
            widget.cancel.call(user);
          }
        }
        isDragging = false;
        position = Offset.zero;
        angle = 0;
        cancelRatio = 0.0;
        confirmRatio = 0.0;
      });
}

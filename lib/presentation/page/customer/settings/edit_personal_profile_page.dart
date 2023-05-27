import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:minder/data/model/personal/user_dto.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/file/controller/file_controller_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/widget/bottom_sheet_component/bottom_sheet_components.dart';
import 'package:minder/presentation/widget/chip/chip_widget.dart';
import 'package:minder/presentation/widget/image_picker/image_picker_widget.dart';
import 'package:minder/presentation/widget/rank/rank.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/enum/gender_enum.dart';
import 'package:minder/util/constant/enum/image_enum.dart';
import 'package:minder/util/constant/enum/position_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/helper/gender_helper.dart';
import 'package:minder/util/helper/position_helper.dart';
import 'package:minder/util/style/base_style.dart';

class EditPersonalProfilePage extends StatefulWidget {
  const EditPersonalProfilePage({super.key});

  @override
  State<EditPersonalProfilePage> createState() =>
      _EditPersonalProfilePageState();
}

class _EditPersonalProfilePageState extends State<EditPersonalProfilePage> {
  late UserDto user;
  final List<Position> selectedPosition = List.empty(growable: true);
  File? avatar;
  File? cover;

  @override
  void initState() {
    GetIt.instance.get<UserCubit>().stream.listen((event) async {
      if (!mounted) return;
      if (event is UserSuccess) {
        await saveFile(userId: user.id!);
      }
    });

    GetIt.instance.get<FileControllerCubit>().stream.listen((event) async {
      if (!mounted) return;
      if (event is FileControllerSuccess) {
        await GetIt.instance.get<UserCubit>().getMe();
        if (mounted) {
          GetIt.instance.get<LoadingCoverController>().off(context);
          Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName));
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserSuccess) {
        user = state.user!;
        selectedPosition.clear();
        if (user.gameSetting != null && user.gameSetting!.positions != null) {}
        selectedPosition.addAll(user.gameSetting!.positions!
            .map((e) => Position.values.elementAt(e))
            .toList());
        return buildContent();
      }
      return Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    });
  }

  Widget buildContent() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(S.current.txt_update_profile, style: BaseTextStyle.label()),
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(0.25),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  GetIt.instance.get<LoadingCoverController>().on(context);
                  GetIt.instance.get<UserCubit>().updateMe(user).then((value) {
                    GetIt.instance.get<LoadingCoverController>().off(context);
                    Navigator.of(context).pop();
                  });
                },
                child: Text(S.current.txt_done,
                    style: BaseTextStyle.body1(color: BaseColor.green500)),
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(S.current.txt_cancel,
                  style: BaseTextStyle.body1(color: BaseColor.grey900)),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: instanceBaseGrid.margin),
                child: Column(
                  children: [
                    buildAvatar(size),
                    const SizedBox(height: 24),
                    buildCover(size),
                    const SizedBox(height: 24),
                    buildInfo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget.common(
          labelText: S.current.lbl_name,
          initialValue: user.name,
          onChanged: (value) => setState(() => user.name = value),
        ),
        const SizedBox(height: 24),
        TextFieldWidget.common(
          initialValue: user.description,
          labelText: S.current.lbl_description,
          onChanged: (value) => setState(() => user.description = value),
        ),

        // Sex
        TileWidget.textField(
          onTap: () {
            BottomSheetComponents.settingSex(
              context: context,
              onSuccess: (value) => setState(() => user.sex = value),
              value: user.sex!,
            );
          },
          labelText: S.current.lbl_sex,
          value:
              GenderHelper.mapKeyToName(Gender.values.elementAt(user.sex ?? 2)),
        ),

        //Day of birth
        TileWidget.textField(
          onTap: () {
            BottomSheetComponents.settingDOB(
              context: context,
              dob: user.dayOfBirth,
              onSuccess: (value) {
                if (value == null) return;
                setState(() => user.dayOfBirth = value.toUtc());
              },
            );
          },
          value: DateFormat('dd/MM/yyyy')
              .format(user.dayOfBirth ?? DateTime.now()),
          iconPath: IconPath.calendarLine,
          labelText: S.current.lbl_birthday,
        ),

        TextWidget.title(title: S.current.lbl_playing_position),
        Wrap(
            direction: Axis.horizontal,
            spacing: 10.0,
            runSpacing: 10.0,
            children: [
              ...Position.values.map((position) => ChipWidget.filter(
                  content: PositionHelper.mapKeyToTitle(position),
                  onTap: () => selectPosition(position),
                  isSelected: selectedPosition.contains(position))),
            ]),

        // Rate Bar
        TextWidget.title(title: S.current.lbl_level),
        Rank.edit(
          rank: user.gameSetting?.rank ?? 0,
          onValueChange: (rank) =>
              setState(() => user.gameSetting?.rank = rank),
        ),
        const SizedBox(height: 24),
        TextFieldWidget.common(
          initialValue: user.phone,
          labelText: S.current.lbl_phone,
          onChanged: (value) => setState(() => user.phone = value),
        ),
        const SizedBox(height: 24),
        TextFieldWidget.common(
          initialValue: user.username,
          labelText: S.current.lbl_email,
          readOnly: true,
          onChanged: (value) => {},
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildCover(Size size) {
    return Column(
      children: [
        Container(
          width: size.width,
          alignment: Alignment.centerLeft,
          child: Text(S.current.lbl_cover,
              style: BaseTextStyle.label(color: BaseColor.grey900)),
        ),
        const SizedBox(height: 12),
        ImagePickerWidget.addRectangle(
          onTap: () => pickImage(isCover: true),
          imagePath: cover,
          url: user.cover,
        ),
      ],
    );
  }

  Widget buildAvatar(Size size) {
    return Column(
      children: [
        Container(
          width: size.width,
          alignment: Alignment.centerLeft,
          child: Text(S.current.lbl_avatar,
              style: BaseTextStyle.label(color: BaseColor.grey900)),
        ),
        const SizedBox(height: 12),
        ImagePickerWidget.addCircle(
          onTap: () => pickImage(isCover: false),
          imagePath: avatar,
          url: user.avatar,
        ),
      ],
    );
  }

  Widget buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        boxShadow: [BaseShadowStyle.appBar],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(S.current.txt_cancel,
                  style: BaseTextStyle.body1(color: BaseColor.grey900)),
            ),
            Text(S.current.txt_update_profile,
                style: BaseTextStyle.label(color: BaseColor.grey900)),
            GestureDetector(
              onTap: () {
                GetIt.instance.get<LoadingCoverController>().on(context);
                GetIt.instance.get<UserCubit>().updateMe(user);
              },
              child: Text(S.current.txt_done,
                  style: BaseTextStyle.body1(color: BaseColor.green500)),
            ),
          ],
        ),
      ),
    );
  }

  void selectPosition(Position position) {
    setState(() {
      if (selectedPosition.contains(position)) {
        selectedPosition.remove(position);
      } else {
        selectedPosition.add(position);
      }
      user.gameSetting!.positions =
          selectedPosition.map((e) => e.index).toList();
    });
  }

  void pickImage({required bool isCover}) async {
    if (isCover) {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result != null) {
        setState(() {
          cover = File(result.path);
        });
      }
    } else {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result != null) {
        setState(() {
          avatar = File(result.path);
        });
      }
    }
  }

  Future<void> saveFile({required String userId}) async {
    if (avatar != null) {
      await GetIt.instance
          .get<FileControllerCubit>()
          .create(id: userId, file: avatar!, type: ImageEnum.ua);
    }
    if (cover != null) {
      await GetIt.instance
          .get<FileControllerCubit>()
          .create(id: userId, file: cover!, type: ImageEnum.uc);
    }
  }
}

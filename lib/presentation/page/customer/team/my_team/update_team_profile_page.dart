import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/file/controller/file_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_cubit.dart';
import 'package:minder/presentation/page/customer/team/select_stadium_type_page.dart';
import 'package:minder/presentation/widget/image_picker/image_picker_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/enum/image_enum.dart';
import 'package:minder/util/constant/enum/stadium_type_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/helper/stadium_type_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class UpdateTeamProfilePage extends StatefulWidget {
  final Team team;

  const UpdateTeamProfilePage({Key? key, required this.team}) : super(key: key);

  @override
  State<UpdateTeamProfilePage> createState() => _UpdateTeamProfilePageState();
}

class _UpdateTeamProfilePageState extends State<UpdateTeamProfilePage> {
  int currentRate = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stadiumTypeController = TextEditingController();

  String? nameErrorText;
  String? codeErrorText;
  String? typeErrorText;
  String? updateTeamErrorText;

  List<StadiumType> stadiumTypes = List.empty(growable: true);

  File? avatar;
  File? cover;

  @override
  void initState() {
    final Team team = widget.team;
    setState(() {
      nameController.text = team.name;
      codeController.text = team.code;
      descriptionController.text = team.description ?? "";
      if (team.gameSetting != null) {
        currentRate = team.gameSetting!.rank!.toInt();
        if (team.gameSetting!.gameTypes != null) {
          stadiumTypes = team.gameSetting!.gameTypes!
              .map((e) => StadiumTypeHelper.mapIntToEnum(type: e.toInt()))
              .toList();
          for (var gameType in team.gameSetting!.gameTypes!) {
            stadiumTypeController.text += gameType.toString();
            if (gameType != team.gameSetting!.gameTypes!.last) {
              stadiumTypeController.text += "/";
            }
          }
        }
      }
    });
    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) async {
      if (!mounted) return;
      GetIt.instance.get<LoadingCoverController>().off(context);
      if (event is TeamControllerCodeEmptyState) {
        setState(() {
          codeErrorText = S.current.txt_err_empty_code;
        });
        return;
      }
      if (event is TeamControllerNameEmptyState) {
        setState(() {
          nameErrorText = S.current.txt_err_empty_name;
        });
        return;
      }
      if (event is TeamControllerCodeExistState) {
        setState(() {
          codeErrorText = S.current.txt_err_exist_code;
        });
        return;
      }
      if (event is TeamControllerStadiumTypeEmptyState) {
        setState(() {
          typeErrorText = S.current.txt_err_empty_stadium_type;
        });
        return;
      }
      if (event is TeamControllerErrorState) {
        setState(() {
          updateTeamErrorText = event.message;
        });
        return;
      }
      if (event is TeamControllerSuccessState) {
        await saveFile(teamId: widget.team.id);
        GetIt.instance.get<TeamsCubit>().getTeams();
        GetIt.instance.get<TeamControllerCubit>().clear();
        if (mounted) {
          Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName));
        }
      }
    });
    GetIt.instance.get<FileControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is FileControllerSuccess) {
        GetIt.instance.get<FileControllerCubit>().clean();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SheetWidget.title(
                context: context,
                title: S.current.lbl_update_team_profile,
                rollbackContent: S.current.btn_cancel,
                onRollback: () => Navigator.pop(context),
                submitContent: S.current.btn_done,
                onSubmit: () => updateTeam()),
            _buildUpdateForm(),
          ],
        ),
      ),
    );
  }

  _buildUpdateForm() {
    final Team team = widget.team;
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget.title(title: S.current.lbl_avatar),
            Center(
                child: ImagePickerWidget.addCircle(
                    url: team.avatar,
                    imagePath: avatar,
                    onTap: () => pickImage(isCover: false))),
            TextWidget.title(title: S.current.lbl_cover),
            Center(
                child: ImagePickerWidget.addRectangle(
                    url: team.cover,
                    imagePath: cover,
                    onTap: () => pickImage(isCover: true))),
            TextWidget.title(title: S.current.lbl_team_name),
            TextFieldWidget.common(
                onChanged: (text) {},
                hintText: S.current.lbl_team_name,
                textEditingController: nameController,
                errorText: nameErrorText),
            TextWidget.title(title: S.current.lbl_key),
            TextFieldWidget.common(
                onChanged: (text) {},
                hintText: S.current.txt_hint_key,
                textEditingController: codeController,
                errorText: codeErrorText),
            TextWidget.title(title: S.current.lbl_description),
            TextFieldWidget.common(
                onChanged: (text) {},
                textEditingController: descriptionController,
                hintText: S.current.lbl_description),
            TextWidget.title(title: S.current.lbl_level),
            _rateBar(),
            TextWidget.title(title: S.current.lbl_stadium_type),
            TextFieldWidget.dropdown(
                onTap: () => selectStadiumType(),
                controller: stadiumTypeController,
                hintText: S.current.txt_hint_stadium_type,
                context: context),
            if (updateTeamErrorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(updateTeamErrorText!,
                    style: BaseTextStyle.body2(color: BaseColor.red500)),
              ),
          ],
        ),
      ),
    );
  }

  _rateBar() {
    return Row(children: List.generate(5, (index) => _star(limit: index + 1)));
  }

  _star({required int limit}) {
    return GestureDetector(
        onTap: () {
          setState(() {
            currentRate = limit;
          });
        },
        child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: currentRate >= limit
                ? BaseIcon.base(IconPath.starFill, color: BaseColor.yellow500)
                : BaseIcon.base(IconPath.starLine, color: BaseColor.grey300)));
  }

  void updateTeam() {
    GetIt.instance.get<LoadingCoverController>().on(context);
    clearError();
    unFocus();
    GetIt.instance.get<TeamControllerCubit>().updateTeam(
        id: widget.team.id,
        name: nameController.text,
        code: codeController.text,
        level: currentRate,
        description: descriptionController.text,
        stadiumType: stadiumTypes);
  }

  void selectStadiumType() async {
    final result = await SheetWidget.base(
        context: context,
        body: SelectStadiumTypePage(
          preStadiumType: stadiumTypes,
        ));
    if (result != null) {
      setState(() {
        stadiumTypes.clear();
        stadiumTypes.addAll(result);
        stadiumTypeController.clear();
        for (var stadiumType in stadiumTypes) {
          stadiumTypeController.text +=
              "${StadiumTypeHelper.mapEnumToInt(stadiumType: stadiumType)}";
          if (stadiumType != stadiumTypes.last) {
            stadiumTypeController.text += "/";
          }
        }
      });
    }
  }

  void clearError() {
    setState(() {
      nameErrorText = null;
      codeErrorText = null;
      typeErrorText = null;
      updateTeamErrorText = null;
    });
  }

  void unFocus() {
    FocusScope.of(context).unfocus();
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

  Future<void> saveFile({required String teamId}) async {
    if (avatar != null) {
      await GetIt.instance
          .get<FileControllerCubit>()
          .create(id: teamId, file: avatar!, type: ImageEnum.ta);
    }
    if (cover != null) {
      await GetIt.instance
          .get<FileControllerCubit>()
          .create(id: teamId, file: cover!, type: ImageEnum.tc);
    }
  }
}

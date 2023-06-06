import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minder/core/failures/team_failures.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/page/customer/team/select_stadium_type_page.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/image_picker/image_picker_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/enum/stadium_type_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/helper/stadium_type_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_size.dart';
import 'package:minder/util/style/base_text_style.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({Key? key}) : super(key: key);

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  int currentRate = 3;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stadiumTypeController = TextEditingController();

  String? nameErrorText;
  String? codeErrorText;
  String? typeErrorText;
  String? createTeamErrorText;

  List<StadiumType> stadiumTypes = List.empty(growable: true);
  File? avatar;
  File? cover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildCreateForm());
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: BaseIcon.base(IconPath.arrowLeftLine),
      ),
      shadowColor: BaseColor.grey500.withOpacity(0.08),
      title: Text(
        S.current.lbl_create_team,
        style: BaseTextStyle.label(),
      ),
      centerTitle: true,
    );
  }

  _buildCreateForm() {
    return BlocListener<TeamControllerCubit, TeamControllerState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is TeamControllerErrorState) {
          createTeamErrorText = state.message;
        }
        if (state is TeamControllerHaveTeamState) {}
        if (state is TeamControllerCodeExistState) {
          codeErrorText = S.current.txt_err_exist_code;
        }

        if (state is TeamControllerSuccessState) {
          GetIt.instance.get<LoadingCoverController>().off(context);
          Navigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget.title(title: S.current.lbl_avatar),
            Center(
                child: ImagePickerWidget.addCircle(
                    onTap: () => pickImage(isCover: false), imagePath: avatar)),
            TextWidget.title(title: S.current.lbl_cover),
            Center(
                child: ImagePickerWidget.addRectangle(
              onTap: () => pickImage(isCover: true),
              imagePath: cover,
            )),
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
                context: context,
                controller: stadiumTypeController,
                hintText: S.current.lbl_stadium_type),
            if (createTeamErrorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(createTeamErrorText!,
                    style: BaseTextStyle.body2(color: BaseColor.red500)),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ButtonWidget.primary(
                  onTap: () => createTeam(), content: S.current.btn_done),
            )
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
            : BaseIcon.base(IconPath.starLine, color: BaseColor.grey300),
      ),
    );
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

  void createTeam() {
    clearError();
    if (!_validate()) return;
    clearError();
    unFocus();
    GetIt.instance.get<LoadingCoverController>().on(context);
    GetIt.instance.get<TeamControllerCubit>().createTeam(
          name: nameController.text,
          code: codeController.text,
          level: currentRate,
          avatarData: avatar,
          coverData: cover,
          description: descriptionController.text,
          stadiumType: stadiumTypes,
        );
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
              "${StadiumTypeHelper.mapEnumToInt(stadiumType: stadiumType)} ";
        }
      });
    }
  }

  void clearError() {
    setState(() {
      nameErrorText = null;
      codeErrorText = null;
      typeErrorText = null;
      createTeamErrorText = null;
    });
  }

  void unFocus() {
    FocusScope.of(context).unfocus();
  }

  bool _validate() {
    if (nameController.text.isEmpty) {
      nameErrorText = S.current.txt_err_empty_name;
    }

    if (nameController.text.length < 8) {
      nameErrorText = S.current.txt_err_name_less_8_character;
    }
    if (codeController.text.isEmpty) {
      codeErrorText = S.current.txt_err_empty_code;
    }

    int codeLength = codeController.text.length;
    if (2 > codeLength || codeLength > 4) {
      codeErrorText = S.current.txt_err_code_lenght;
    }

    setState(() {});
    return nameErrorText == null &&
        codeErrorText == null &&
        typeErrorText == null;
  }
}

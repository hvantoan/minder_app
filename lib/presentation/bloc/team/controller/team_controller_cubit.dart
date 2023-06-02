import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:minder/core/failures/common_failures.dart';
import 'package:minder/core/failures/team_failures.dart';
import 'package:minder/data/model/authentication/login_model.dart';
import 'package:minder/data/repository/implement/team_repository_impl.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/usecase/implement/authentication_usecase_impl.dart';
import 'package:minder/domain/usecase/implement/team_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/enum/stadium_type_enum.dart';
import 'package:minder/util/helper/stadium_type_helper.dart';

part 'team_controller_state.dart';

class TeamControllerCubit extends Cubit<TeamControllerState> {
  TeamControllerCubit() : super(TeamControllerInitial());

  Future<void> createTeam(
      {required String name,
      required String code,
      required int level,
      required List<StadiumType> stadiumType,
      String? description}) async {
    final response = await TeamUseCase().createTeam(
        name: name,
        code: code,
        level: level,
        stadiumType: stadiumType
            .map((e) => StadiumTypeHelper.mapEnumToInt(stadiumType: e))
            .toList());
    if (response.isLeft) {
      if (response.left is EmptyTeamNameFailures) {
        emit(TeamControllerNameEmptyState());
        return;
      }
      if (response.left is EmptyTeamCodeFailures) {
        emit(TeamControllerCodeEmptyState());
        return;
      }
      if (response.left is EmptyTeamTypeFailures) {
        emit(TeamControllerStadiumTypeEmptyState());
        return;
      }
      if (response.left is TeamCodeExistFailures) {
        emit(TeamControllerCodeExistState());
        return;
      }
      if (response.left is HaveTeamFailures) {
        emit(TeamControllerHaveTeamState());
        return;
      }
      if (response.left is ServerFailures) {
        emit(TeamControllerErrorState(
            message: S.current.txt_can_not_connect_server));
        return;
      }
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }
    emit(TeamControllerSuccessState(id: response.right));
  }

  Future<void> updateTeam(
      {required String id,
      required String name,
      required String code,
      required int level,
      required List<StadiumType> stadiumType,
      String? description}) async {
    final response = await TeamUseCase().updateTeam(
        id: id,
        name: name,
        code: code,
        level: level,
        stadiumType: stadiumType
            .map((e) => StadiumTypeHelper.mapEnumToInt(stadiumType: e))
            .toList());
    if (response.isLeft) {
      if (response.left is EmptyTeamNameFailures) {
        emit(TeamControllerNameEmptyState());
        return;
      }
      if (response.left is EmptyTeamCodeFailures) {
        emit(TeamControllerCodeEmptyState());
        return;
      }
      if (response.left is EmptyTeamTypeFailures) {
        emit(TeamControllerStadiumTypeEmptyState());
        return;
      }
      if (response.left is TeamCodeExistFailures) {
        emit(TeamControllerCodeExistState());
        return;
      }
      if (response.left is ServerFailures) {
        emit(TeamControllerErrorState(
            message: S.current.txt_can_not_connect_server));
        return;
      }
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }
    emit(TeamControllerSuccessState());
  }

  Future<void> enterMemberName(
      {required String memberName, required String teamId}) async {
    final response = await TeamRepository()
        .grantOwner(memberName: memberName, teamId: teamId);

    if (response.isLeft) {
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
  }

  Future<void> verify(
      {required String username, required String password}) async {
    final loginRepository =
        await AuthenticationUseCase().login(LoginModel(username, password));
    if (loginRepository.isLeft) {
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
  }

  Future<void> accept({required String id, bool isJoin = true}) async {
    final response = await TeamUseCase().accept(id: id, isJoin: isJoin);
    if (response.isLeft) {
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
  }

  Future<void> join({required String teamId, String? userId}) async {
    final response = await TeamUseCase().join(teamId: teamId, userId: userId);
    if (response.isLeft) {
      if (response.left is AlreadyJoinRequestFailure) {
        emit(TeamControllerErrorState(
            message: S.current.txt_already_join_request));
        return;
      }
      if (response.left is AlreadyInviteFailure) {
        emit(TeamControllerErrorState(message: S.current.txt_already_invite));
        return;
      }
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
  }

  Future<void> kick({required String userId}) async {
    final response = await TeamUseCase().kick(userId: userId);
    if (response.isLeft) {
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
  }

  Future<void> leave({required String teamId}) async {
    final response = await TeamUseCase().leave(teamId: teamId);
    if (response.isLeft) {
      if (response.left is HaveTeamFailures) {
        emit(TeamControllerHaveTeamState());
        return;
      }
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
  }

  Future<void> updateGameTime(Team team) async {
    final response = await TeamUseCase().updateGameTime(team);
    if (response.isLeft) {
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
  }

  Future<void> updateLocation(Team team) async {
    final response = await TeamUseCase().updateLocation(team);
    if (response.isLeft) {
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
  }

  Future<void> inviteUser(
      {required String userId,
      required String teamId,
      required bool hasInvite}) async {
    final response = await TeamUseCase()
        .inviteUser(teamId: teamId, userId: userId, hasInvite: hasInvite);
    if (response.isLeft) {
      emit(
          TeamControllerErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(TeamControllerSuccessState());
    
  }

  void clear() {
    emit(TeamControllerInitial());
  }
}

import 'dart:io';

import 'package:either_dart/either.dart';
// ignore: implementation_imports
import 'package:either_dart/src/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/implement/team_repository_impl.dart';
import 'package:minder/domain/entity/invite/invite.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/domain/usecase/interface/i_team_usecase.dart';

class TeamUseCase extends TeamUseCaseInterface {
  @override
  Future<Either<Failures, List<Team>>> getTeams({bool isMyTeam = true}) async {
    final response = await TeamRepository().getTeams(isMyTeam: isMyTeam);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, String>> createTeam(
      {required String name,
      required String code,
      required int level,
      required List<int> stadiumType,
      File? avatarData,
      File? coverData,
      String? description}) async {
    final response = await TeamRepository().createTeam(
        name: name,
        code: code,
        level: level,
        stadiumType: stadiumType,
        avatarData: avatarData,
        coverData: coverData);
    if (response.isLeft) return Left(response.left);
    return Right(response.right);
  }

  @override
  Future<Either<Failures, Team>> getTeamById({required String teamId}) async {
    final response = await TeamRepository().getTeamById(teamId: teamId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> updateTeam(
      {required String id,
      required String name,
      required String code,
      required int level,
      required List<int> stadiumType,
      String? description}) async {
    final response = await TeamRepository().updateTeam(
        name: name, code: code, level: level, stadiumType: stadiumType, id: id);
    if (response.isLeft) return Left(response.left);
    return const Right(null);
  }

  @override
  Future<Either<Failures, String>> grantOwner(
      {required String teamId, required String memberName}) async {
    final response = await TeamRepository()
        .grantOwner(memberName: memberName, teamId: teamId);
    if (response.isLeft) return Left(response.left);
    return Right(response.right);
  }

  @override
  Future<Either<Failures, List<Invite>>> getInviteTeams(
      {String? teamId}) async {
    final response = await TeamRepository().getInviteTeams(teamId: teamId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> accept(
      {required String id, bool isJoin = true}) async {
    final response = await TeamRepository().accept(id: id, isJoin: isJoin);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> join(
      {required String teamId, String? userId}) async {
    final response =
        await TeamRepository().join(teamId: teamId, userId: userId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> kick({required String userId}) async {
    final response = await TeamRepository().kick(userId: userId);
    if (response.isLeft) return Left(response.left);
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> leave({required String teamId}) async {
    final response = await TeamRepository().leave(teamId: teamId);
    if (response.isLeft) return Left(response.left);
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> updateGameTime(Team team) async {
    final response = await TeamRepository().updateGameTime(team);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> updateLocation(Team team) async {
    final response = await TeamRepository().updateLocation(team);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, List<User>>> getSuggest(
      {required String teamId}) async {
    final response = await TeamRepository().getSuggest(teamId: teamId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> inviteUser(
      {required String teamId,
      required String userId,
      required bool hasInvite}) async {
    final response = await TeamRepository()
        .inviteUser(teamId: teamId, userId: userId, hasInvite: hasInvite);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, List<Team>>> getSuggestTeam(
      {required String teamId}) async {
    final response = await TeamRepository().getSuggestTeam(teamId: teamId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, List<Team>>> find({
    int pageIndex = 0,
    int pageSize = 10,
    int? member,
    int? rank,
    int? age,
    int? position,
    int? gameType,
    int? day,
    int? time,
  }) async {
    final response = await TeamRepository().find(
      pageIndex: pageIndex,
      pageSize: pageIndex,
      member: member,
      rank: rank,
      position: position,
      gameType: gameType,
      day: day,
      time: time,
    );
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }
}

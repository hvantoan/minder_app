import 'package:either_dart/either.dart';
// ignore: implementation_imports
import 'package:either_dart/src/either.dart';
import 'package:minder/core/exception/team_exception.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/core/failures/team_failures.dart';
import 'package:minder/data/repository/implement/user_repository_impl.dart';
import 'package:minder/data/repository/interface/i_team_repository.dart';
import 'package:minder/data/service/team/team_api.dart';
import 'package:minder/domain/entity/invite/invite.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/util/helper/failures_helper.dart';

class TeamRepository extends TeamRepositoryInterface {
  @override
  Future<Either<Failures, List<Team>>> getTeams({bool isMyTeam = true}) async {
    try {
      final response = await TeamAPI().getTeams(isMyTeam: isMyTeam);
      final List<Team> teams =  response.map((e) => Team.fromModel(e)).toList();
      return Right(teams);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, String>> createTeam(
      {required String name,
      required String code,
      required int level,
      required List<int> stadiumType,
      String? description}) async {
    if (name.isEmpty) {
      return Left(EmptyTeamNameFailures());
    }
    if (code.isEmpty) {
      return Left(EmptyTeamCodeFailures());
    }
    if (stadiumType.isEmpty) {
      return Left(EmptyTeamTypeFailures());
    }
    try {
      final response = await TeamAPI().createTeam(
          name: name, code: code, level: level, stadiumType: stadiumType);
      return Right(response);
    } catch (e) {
      if (e is TeamCodeExistException) {
        return Left(TeamCodeExistFailures());
      }
      if (e is HaveTeamException) {
        return Left(HaveTeamFailures());
      }
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, Team>> getTeamById({required String teamId}) async {
    try {
      final response = await TeamAPI().getTeamById(teamId: teamId);
      final Team team = Team.fromModel(response);
      return Right(team);
    } catch (e) {
      if (e is TeamNotExistException) {
        return Left(TeamNotExistFailures());
      }
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, String>> grantOwner(
      {required String memberName, required String teamId}) async {
    try {
      final response = await TeamAPI().getTeamById(teamId: teamId);
      final Team team = Team.fromModel(response);
      String userId = team.members
              ?.firstWhere((element) =>
                  element.user!.name!.toLowerCase().trim() ==
                  memberName.toLowerCase().trim())
              .userId ??
          "";
      return Right(userId);
    } catch (e) {
      if (e is TeamNotExistException) {
        return Left(TeamNotExistFailures());
      }
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> updateTeam(
      {required String id,
      required String name,
      required String code,
      required int level,
      required List<int> stadiumType,
      String? description}) async {
    if (name.isEmpty) {
      return Left(EmptyTeamNameFailures());
    }
    if (code.isEmpty) {
      return Left(EmptyTeamCodeFailures());
    }
    if (stadiumType.isEmpty) {
      return Left(EmptyTeamTypeFailures());
    }
    try {
      await TeamAPI().updateTeam(
          id: id,
          name: name,
          code: code,
          level: level,
          stadiumType: stadiumType);
      return const Right(null);
    } catch (e) {
      if (e is TeamCodeExistException) {
        return Left(TeamCodeExistFailures());
      }
      if (e is HaveTeamException) {
        return Left(HaveTeamFailures());
      }
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, List<Invite>>> getInviteTeams(
      {String? teamId}) async {
    try {
      final response = await TeamAPI().getInvitedTeams(teamId: teamId);
      final List<Invite> invite =
          response.map((e) => Invite.fromModel(e)).toList();
      if (teamId != null) {
        for (var element in invite) {
          final user =
              (await UserRepository().getUser(uid: element.userId)).right;
          element.user = user;
        }
      } else {
        for (var element in invite) {
          final team = (await getTeamById(teamId: element.teamId)).right;
          element.team = team;
        }
      }
      return Right(invite);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> accept(
      {required String id, bool isJoin = true}) async {
    try {
      await TeamAPI().accept(id: id, isJoin: isJoin);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> join(
      {required String teamId, String? userId}) async {
    try {
      await TeamAPI().joinTeam(teamId: teamId, userId: userId);
      return const Right(null);
    } catch (e) {
      if (e is AlreadyJoinRequestException) {
        return Left(AlreadyJoinRequestFailure());
      }
      if (e is AlreadyInviteException) {
        return Left(AlreadyInviteFailure());
      }
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> kick({required String userId}) async {
    try {
      await TeamAPI().kick(userId: userId);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> leave({required String teamId}) async {
    try {
      await TeamAPI().leave(teamId: teamId);
      return const Right(null);
    } catch (e) {
      if (e is HaveTeamException) {
        return Left(HaveTeamFailures());
      }
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> updateGameTime(Team team) async {
    try {
      await TeamAPI().updateGameTime(team);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> updateLocation(Team team) async {
    try {
      await TeamAPI().updateLocation(team);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, List<User>>> getSuggest(
      {required String teamId}) async {
    try {
      final response = await TeamAPI().getSuggest(teamId: teamId);
      final List<User> users = List.empty(growable: true);
      users.addAll(response.map((e) => User.fromModel(e)));
      return Right(users);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> inviteUser(
      {required String teamId,
      required String userId,
      required bool hasInvite}) async {
    try {
      await TeamAPI()
          .inviteUser(teamId: teamId, userId: userId, hasInvite: hasInvite);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, List<Team>>> getSuggestTeam(
      {required String teamId}) async {
    try {
      final response = await TeamAPI().getSuggestTeam(teamId: teamId);
      final List<Team> teams = response.map((e) => Team.fromModel(e)).toList();
      return Right(teams);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }
}

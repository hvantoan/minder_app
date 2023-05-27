import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/entity/invite/invite.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';

abstract class TeamUseCaseInterface {
  Future<Either<Failures, List<Team>>> getTeams({bool isMyTeam = true});

  Future<Either<Failures, List<Invite>>> getInviteTeams({String? teamId});

  Future<Either<Failures, String>> createTeam(
      {required String name,
      required String code,
      required int level,
      required List<int> stadiumType,
      String? description});

  Future<Either<Failures, void>> updateTeam(
      {required String id,
      required String name,
      required String code,
      required int level,
      required List<int> stadiumType,
      String? description});

  Future<Either<Failures, Team>> getTeamById({required String teamId});

  Future<Either<Failures, String>> grantOwner(
      {required String teamId, required String memberName});

  Future<Either<Failures, void>> accept(
      {required String id, bool isJoin = true});

  Future<Either<Failures, void>> join({required String teamId, String? userId});

  Future<Either<Failures, void>> kick({required String userId});

  Future<Either<Failures, void>> leave({required String teamId});

  Future<Either<Failures, void>> updateGameTime(Team team);

  Future<Either<Failures, void>> updateLocation(Team team);

  Future<Either<Failures, List<User>>> getSuggest({required String teamId});

  Future<Either<Failures, void>> inviteUser(
      {required String teamId,
      required String userId,
      required bool hasInvite});

  Future<Either<Failures, List<Team>>> getSuggestTeam({required String teamId});
}

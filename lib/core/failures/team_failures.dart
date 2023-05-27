import 'package:minder/core/failures/failures.dart';

class TeamFailures extends Failures {}

class TeamCodeExistFailures extends TeamFailures {}

class HaveTeamFailures extends TeamFailures {}

class TeamNotExistFailures extends TeamFailures {}

class EmptyTeamNameFailures extends TeamFailures {}

class EmptyTeamCodeFailures extends TeamFailures {}

class EmptyTeamTypeFailures extends TeamFailures {}

class AlreadyJoinRequestFailure extends TeamFailures {}

class AlreadyInviteFailure extends TeamFailures {}

class TeamException implements Exception {}

class TeamCodeExistException extends TeamException {}

class HaveTeamException extends TeamException {}

class TeamNotExistException extends TeamException {}

class AlreadyJoinRequestException extends TeamException {}

class AlreadyInviteException extends TeamException {}

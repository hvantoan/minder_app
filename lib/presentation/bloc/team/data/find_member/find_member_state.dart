part of 'find_member_cubit.dart';

abstract class FindMemberState {}

class FindMemberInitial extends FindMemberState {}

class FindMemberFailure extends FindMemberState {
  final String message;

  FindMemberFailure(this.message);
}

class FindMemberSuccess extends FindMemberState {
  final List<User> allUsers;
  final List<Invite> invites;

  FindMemberSuccess(this.allUsers, this.invites);
}

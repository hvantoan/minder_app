part of 'group_cubit.dart';

@immutable
abstract class GroupState {}

class GroupInitialState extends GroupState {}

class GroupLoadedState extends GroupState {
  final List<Group> groups;

  GroupLoadedState({required this.groups});

  List<Object> get props => [groups];
}

class GroupErrorState extends GroupState {}

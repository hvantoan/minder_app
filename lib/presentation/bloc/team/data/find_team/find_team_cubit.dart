import 'package:bloc/bloc.dart';
import 'package:minder/domain/entity/invite/invite.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/usecase/implement/team_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';

part 'find_team_state.dart';

class FindTeamCubit extends Cubit<FindTeamState> {
  FindTeamCubit() : super(FindTeamInitial());

  Future<void> find({
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
    final suggest = await TeamUseCase().find(
      pageIndex: pageIndex,
      pageSize: pageSize,
      member: member,
      rank: rank,
      position: position,
      gameType: gameType,
      day: day,
      time: time,
    );
    if (suggest.isLeft) {
      emit(FindTeamFailure(message: S.current.txt_data_parsing_failed));
      return;
    }

    final inviteTeams = await TeamUseCase().getInviteTeams();
    if (inviteTeams.isLeft) {
      emit(FindTeamFailure(message: S.current.txt_data_parsing_failed));
      return;
    }

    // final myTeams = await TeamUseCase().getTeams(isMyTeam: true);
    if (inviteTeams.isLeft) {
      emit(FindTeamFailure(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(FindTeamSuccess(
        suggest: suggest.right, inviteTeams: inviteTeams.right));
  }

  Future<void> getTeams({required String teamId}) async {
    final suggest = await TeamUseCase().getSuggestTeam(teamId: teamId);
    if (suggest.isLeft) {
      emit(FindTeamFailure(message: S.current.txt_data_parsing_failed));
      return;
    }

    final inviteTeams = await TeamUseCase().getInviteTeams();
    if (inviteTeams.isLeft) {
      emit(FindTeamFailure(message: S.current.txt_data_parsing_failed));
      return;
    }

    // final myTeams = await TeamUseCase().getTeams(isMyTeam: true);
    if (inviteTeams.isLeft) {
      emit(FindTeamFailure(message: S.current.txt_data_parsing_failed));
      return;
    }

    emit(FindTeamSuccess(
        suggest: suggest.right, inviteTeams: inviteTeams.right));
  }

  void clean() => emit(FindTeamInitial());
}

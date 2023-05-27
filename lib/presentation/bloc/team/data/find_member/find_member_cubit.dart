import 'package:bloc/bloc.dart';
import 'package:minder/domain/entity/invite/invite.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/domain/usecase/implement/team_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';

part 'find_member_state.dart';

class FindMemberCubit extends Cubit<FindMemberState> {
  FindMemberCubit() : super(FindMemberInitial());

  Future<void> getData({required String teamId}) async {
    final suggests = await TeamUseCase().getSuggest(teamId: teamId);
    if (suggests.isLeft) {
      emit(FindMemberFailure(S.current.txt_data_parsing_failed));
      return;
    }

    final invites = await TeamUseCase().getInviteTeams(teamId: teamId);
    if (invites.isLeft) {
      emit(FindMemberFailure(S.current.txt_data_parsing_failed));
      return;
    }

    final myTeam = await TeamUseCase().getTeamById(teamId: teamId);
    if (myTeam.isLeft) {
      emit(FindMemberFailure(S.current.txt_data_parsing_failed));
      return;
    }

    emit(FindMemberSuccess(suggests.right, invites.right));
  }

  void clean() => emit(FindMemberInitial());
}

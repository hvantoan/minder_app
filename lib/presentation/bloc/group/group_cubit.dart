import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/entity/group/group.dart';
import 'package:minder/domain/usecase/implement/group_usecase_impl.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitialState());

  load({required int pageIndex, required int pageSize}) async {
    Either<Failures, List<Group>> groups =
        await GroupUsecase().list(pageIndex: pageIndex, pageSize: pageSize);
    if (groups.isRight) {
      emit(GroupLoadedState(groups: groups.right));
    } else {
      emit(GroupErrorState());
    }
  }
}

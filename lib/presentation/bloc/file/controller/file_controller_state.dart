part of 'file_controller_cubit.dart';

abstract class FileControllerState {}

class FileControllerInitial extends FileControllerState {}

class FileControllerSuccess extends FileControllerState {}

class FileControllerFailure extends FileControllerState {
  final String message;

  FileControllerFailure(this.message);
}

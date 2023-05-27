import 'package:minder/core/failures/authentication_failures.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:either_dart/either.dart';

class AuthenticationHelper {
  static Either<Failures, void> validUsername(String username) {
    RegExp validEmail = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (username.isEmpty) return Left(EmptyDataFailures());
    if (!validEmail.hasMatch(username)) return Left(InvalidEmailFailures());
    return const Right(null);
  }

  static Either<Failures, void> validPassword(String password) {
    RegExp moreThan8Char = RegExp(r"^.{8,}$");
    RegExp noSpace = RegExp(r"^(?!.* )");
    if (password.isEmpty) return Left(EmptyDataFailures());
    if (!moreThan8Char.hasMatch(password)) return Left(LessThan8CharFailures());
    if (!noSpace.hasMatch(password)) return Left(HaveSpaceFailures());
    return const Right(null);
  }

  static Either<Failures, void> validConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return Left(EmptyDataFailures());
    if (confirmPassword.compareTo(password) != 0) {
      return Left(ConfirmPasswordFailures());
    }
    return const Right(null);
  }

  static Either<Failures, void> validName(String name) {
    if (name.isEmpty) return Left(EmptyDataFailures());
    return const Right(null);
  }

  static Either<Failures, void> validPhone(String phone) {
    if (phone.isEmpty) return Left(EmptyDataFailures());
    return const Right(null);
  }
}

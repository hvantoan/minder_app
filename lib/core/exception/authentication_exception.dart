import 'package:minder/debug/debug.dart';

class AuthenticationException implements Exception {}

class UnregisteredUsernameException extends AuthenticationException {
  UnregisteredUsernameException() : super() {
    DebugHelper.printException(exception: "UnregisteredUsernameException");
  }
}

class WrongPasswordException extends AuthenticationException {
  WrongPasswordException() : super() {
    DebugHelper.printException(exception: "WrongPasswordException");
  }
}

class WrongRefreshTokenException extends AuthenticationException {
  WrongRefreshTokenException() : super() {
    DebugHelper.printException(exception: "WrongRefreshTokenException");
  }
}

class IncorresctOTPException extends AuthenticationException {
  IncorresctOTPException() : super() {
    DebugHelper.printException(exception: "IncorresctOTPException");
  }
}

class PhoneEmptyException extends AuthenticationException {
  PhoneEmptyException() : super() {
    DebugHelper.printException(exception: "PhoneEmptyException");
  }
}

class RegisteredUsernameException extends AuthenticationException {
  RegisteredUsernameException() : super() {
    DebugHelper.printException(exception: "RegisteredUsernameException");
  }
}

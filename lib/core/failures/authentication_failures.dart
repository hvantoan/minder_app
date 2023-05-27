import 'package:minder/core/failures/failures.dart';

class UnregisteredUsernameFailures extends Failures {
  UnregisteredUsernameFailures()
      : super(message: "Unregistered Username Failures");
}

class WrongPasswordFailures extends Failures {
  WrongPasswordFailures() : super(message: "Wrong Password Failures");
}

class WrongRefreshTokenFailures extends Failures {
  WrongRefreshTokenFailures() : super(message: "Wrong Refresh Token Failures");
}

class EmptyDataFailures extends Failures {
  EmptyDataFailures() : super(message: "Empty Data Failures");
}

class InvalidEmailFailures extends Failures {
  InvalidEmailFailures() : super(message: "Invalid Email Failures");
}

class LessThan8CharFailures extends Failures {
  LessThan8CharFailures() : super(message: "less than 8 chars Failures");
}

class HaveSpaceFailures extends Failures {
  HaveSpaceFailures() : super(message: "Password have Space Failures");
}

class RegisteredUsernameFailures extends Failures {
  RegisteredUsernameFailures() : super(message: "Registered Username Failures");
}

class MismatchedPasswordFailures extends Failures {
  MismatchedPasswordFailures() : super(message: "Mismatched Password Failures");
}

class EmptyNameFailures extends Failures {
  EmptyNameFailures() : super(message: "Empty Name Failures");
}

class EmptyPhoneNumberFailures extends Failures {
  EmptyPhoneNumberFailures() : super(message: "Empty Phone Number Failures");
}

class InvalidPhoneNumberFailures extends Failures {
  InvalidPhoneNumberFailures()
      : super(message: "Invalid Phone Number Failures");
}

class ConfirmPasswordFailures extends Failures {
  ConfirmPasswordFailures() : super(message: "Confirm Password Failures");
}

class IncorresctOTPFailures extends Failures {
  IncorresctOTPFailures() : super(message: "The OTP Code Failures");
}

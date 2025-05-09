import 'package:coaching_ai_new/constants/strings.dart';


final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

String? validateEmail(String? val) {
  if (val == null || !emailRegex.hasMatch(val)) return AppStrings.emailError;
  return null;
}

String? validatePassword(String? val) {
  if (val == null || !passwordRegex.hasMatch(val)) {
    return 'Min 8 chars, 1 upper, 1 lower, 1 number';
  }
  return null;
}

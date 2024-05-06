import 'constants.dart';

String? validateEmail(String? value) {
  String? _msg;
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value!.isEmpty) {
    _msg = Constants.EMAIL_REQUIRE;
  } else if (!regex.hasMatch(value)) {
    _msg = Constants.EMAIL_VALID;
  }
  return _msg;
}

bool? validateEmailbool(String value) {
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    return false;
  } else if (!regex.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

String? validatePassword(String? value) {
  String? _msg;
  if (value!.isEmpty) {
    _msg = Constants.PAS_REQUIRE;
  }
  return _msg;
}

String? validateCompanyId(String? value) {
  String? _msg;
  if (value!.isEmpty) {
    _msg = Constants.COMP_ID_REQUIRE;
  }
  return _msg;
}

String? validateConfirm(String? pwd, String? confirmPwd) {
  String? _msg;
  if (confirmPwd!.isEmpty) {
    _msg = Constants.PAS_REQUIRE;
  } else if (pwd != confirmPwd) {
    _msg = Constants.CON_PWD;
  }
  return _msg;
}

String? validatePhoneNum(String? value) {
  String? _msg;

  if (value!.isEmpty) {
    _msg = Constants.PHONE_REQUIRE;
  } else if (value.length < 12) {
    _msg = Constants.PHONE_CHARA;
  }
  return _msg;
}

String? validateInputData(value, validatorRequired) {
  if (validatorRequired == true) {
    if (value == null || value.isEmpty) {
      return Constants.INPUT_REQUIRE;
    } else {
      return null;
    }
  }
  return null;
}

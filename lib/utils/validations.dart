class FieldValidators {
  static String? emailFieldValidation(String value) {
    if (value.isEmpty) return "Please Enter Email ";

    RegExp regExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (value.isNotEmpty && !regExp.hasMatch(value)) {
      return "Please Enter Valid Email ";
    }
    return null;
  }

  static String? passwordValidation(String value) {
    if (value.isEmpty) return "Please Enter Password";
    return null;
  }
}

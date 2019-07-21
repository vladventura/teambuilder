enum FormType {login, register}

class EmailValidator{
  static String validate(String value){
    if (value.isEmpty) return "Email cannot be empty";
    if (!value.contains('@')) return "Email is not valid";
    return null;
  }
}

class PasswordValidator{
  static String validate(String value){
    if (value.isEmpty) return "Password cannot be empty";
    if (value.contains('!')) return "Password must not contain special characters";
    if (value.contains(' ')) return "Password must not contain spaces";
    return null;
  }
}
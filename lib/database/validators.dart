/* 
  This is a two function file. 
  It enumerates the kinds of forms that could happen, which renders my create page useless.
  It also holds the validators for each form field.
*/

enum FormType {login, register}

class UsernameValidator{
  static String validate(String value){
    if (value.isEmpty) return "Username may not be empty";
    return null;
  }
}

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
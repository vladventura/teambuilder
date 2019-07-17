class UserExeption implements Exception{
  UserExeption(String c){
    final String cause = c;
    switch (cause){
      case 'email': print("Email already in Database. Insert Error");
                    break;
      case 'user': print("User already in Database. Insert Error");
                   break;
    }
  }
}
class User{
  int id;
  String username;
  String password;
  String email;

  Map <String, dynamic> toMap(){
    return{
      'id': id,
      'username': username,
      'password': password,
      'email': email
    };
  }
}
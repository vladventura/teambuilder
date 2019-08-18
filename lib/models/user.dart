class User{
  List <dynamic> joinedProjects;
  List <dynamic> createdProjects;

  User(this.createdProjects, this.joinedProjects);

  Map<String, dynamic> toMap(){
    return {
      'createdProjects': this.createdProjects,
      'joinedProjects': this.joinedProjects,
    };
  }
}
class Project{
  String complexity;
  String contactPlatforms;
  String description;
  List <String> joinedUsers;
  String name;
  String originator;
  List<String> languagesUsed;

  Project(
    this.complexity, 
    this.contactPlatforms, 
    this.description, 
    this.name,
    this.joinedUsers, 
    this.originator,
    this.languagesUsed
  );

  Map <String, dynamic> toMap(){
    return{
      'complexity': this.complexity,
      'contactPlatforms': 'Feature coming soon',
      'description': this.description,
      'name': this.name,
      'joinedUsers': this.joinedUsers,
      'originator': this.originator,
      'languagesUsed': this.languagesUsed,
    };
  }
}
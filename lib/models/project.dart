class Project{
  int originatorId;
  String name;
  String description;
  String complexity;
  String contactPlatforms;
  String originator;

  Map <String, dynamic> toMap(){
    return{
      'originator_id': originatorId,
      'name': name,
      'description': description,
      'complexity': complexity,
      'contactPlatforms': contactPlatforms,
      'originator': originator,
    };
  }
}
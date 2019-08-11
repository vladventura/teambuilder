class Project{
  // It should be user-id and there should also be a creator name too
  int id;
  String name;
  String description;
  String complexity;
  String contactPlatforms;
  String originator;

  Project(this.originatorId, this.name, this.description, this.complexity, this.contactPlatforms, this.originator);

  Map <String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'description': description,
      'complexity': complexity,
      'contactPlatforms': contactPlatforms,
      'originator': originator,
    };
  }
}
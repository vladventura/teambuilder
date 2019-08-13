class Project{
  String complexity;
  String contactPlatforms;
  String description;
  String name;
  String originator;
  String originatorId;

  Project(
    this.complexity, 
    this.contactPlatforms, 
    this.description, 
    this.name, 
    this.originator,
    this.originatorId, 
  );

  Map <String, dynamic> toMap(){
    return{
      'complexity': complexity,
      'contactPlatforms': 'Feature coming soon',
      'description': description,
      'name': name,
      'originator': originator,
      'originator_id': originatorId,
    };
  }
}
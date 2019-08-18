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
      'complexity': this.complexity,
      'contactPlatforms': 'Feature coming soon',
      'description': this.description,
      'name': this.name,
      'originator': this.originator,
      'originator_id': this.originatorId,
    };
  }
}
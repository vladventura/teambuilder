import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home:FirestoreCRUDPage()
  ));
}

class FirestoreCRUDPage extends StatefulWidget{
  _FirestoreCRUDPageState createState() => _FirestoreCRUDPageState();
}

class _FirestoreCRUDPageState extends State<FirestoreCRUDPage>{
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Practice round'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.amber)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: id != null? readData: null,
                child: Text('Read',style: TextStyle(color: Colors.amber)),
                color: Colors.blue,
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('projects').snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Column(
                  children: snapshot.data.documents.map((document) => buildItem(document)).toList(),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),

    );
  }

  Card buildItem(DocumentSnapshot document){
    return Card(
      color: Colors.black,
      
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${document.data["name"]}', style: TextStyle(color: Colors.amber, fontSize: 24),),
            Text('Todo: ${document.data["todo"]}', style: TextStyle(color: Colors.grey, fontSize: 20),),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(document),
                  child: Text('Update Todo', style: TextStyle(color: Colors.orange)),
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(document),
                  child: Text('Delete Todo', style: TextStyle(color: Colors.red))
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField(){
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value){
        if (value.isEmpty){
          return 'Please enter some text';
        }
      },
      onSaved: (value) => name = value,
    );
  }

  void createData() async{
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      DocumentReference reference = await db.collection('projects').add({
        'name': '$name'
      });
      setState(() => id = reference.documentID);
      print(reference.documentID);
    }
  }
  void readData() async{
    DocumentSnapshot snapshot = await db.collection('projects').document(id).get();
    print(snapshot.data['name']);
  }
  void updateData(DocumentSnapshot document) async{
    await db.collection('projects').document(document.documentID).updateData({'todo': 'implement a real update method'});
  }
  void deleteData(DocumentSnapshot document) async{
    await db.collection('projects').document(document.documentID).delete();
  }
}

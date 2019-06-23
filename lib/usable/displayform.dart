import  'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:teambuilder/util/constants.dart';

class DisplayForm extends StatefulWidget{
  @override
  _DisplayFormState createState() => _DisplayFormState();
}

class _DisplayFormState extends State<DisplayForm>{
  String _value;
  List <String> values = new List <String>();

  @override
  void initState(){
    values.addAll(['Beginner', 'Intermediate', 'Expert']);
  }

  void _onChanged(String value){
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build (BuildContext context){
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            width: 300,
            padding: EdgeInsets.only(bottom: 5),
              child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.go,
              autocorrect: true,
              autovalidate: true,
              decoration: InputDecoration(
                // TODO: Move this code to another place to only write once
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    color: Constants.main_color,
                    width: 2.0
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.side_color,
                    width: 2.0
                  )
                ),
                labelText: 'Project Name',
              ),
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: TextFormField(
              maxLines: 5,
              maxLength: 500,
              maxLengthEnforced: true,
              autocorrect: true,
              autovalidate: true,
              // TODO: Make the lines take a certain amount of characters
              decoration: InputDecoration(
                labelText: 'Project Description',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    color: Constants.main_color,
                    width: 2.0
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.side_color,
                    width: 2.0
                  )
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Constants.side_color, width: 2)
            ),
            child: DropdownButtonHideUnderline(
              child:DropdownButton(
                hint: Text('Complexity'),
                value: _value,
                onChanged: (String value){
                _onChanged(value);
              },
              items: values.map((String value){
                return new DropdownMenuItem(value: value, child: Text(value));
              }).toList()
            )
          )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Center(
             child: FlatButton(
               color: Colors.transparent,
               child: Icon(Icons.add),
               onPressed: ((){
               }),
             ) 
            )
          )
        ],
      )
    );
  }
}
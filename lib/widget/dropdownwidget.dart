import 'package:flutter/material.dart';

class DropDownList extends StatelessWidget {
  DropDownList({required this.name,required this.call,  super.key});
 
final name;
final call;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      child: ListTile(title: Text(name),),
      onTap: () => call(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hu_health_care_mania/screens/menu_list.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      title:'HealthCareMania',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink
      ),
      home: MenuList(),
    );
  }
}
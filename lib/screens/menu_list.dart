import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hu_health_care_mania/models/project.dart';
import 'package:hu_health_care_mania/utils/database_helper.dart';
import 'package:hu_health_care_mania/screens/menu_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class MenuList extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){

    return MenuListState();
  }
}

class MenuListState extends State<MenuList>{

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Menu> menuList;
  int count = 0;

  @override
  Widget build(BuildContext context){

    if (menuList == null){
      menuList = <Menu>[];
      updateListView();
    }

    return Scaffold(

    )
  }
}
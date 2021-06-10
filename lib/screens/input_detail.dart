import 'package:hu_health_care_mania/models/item.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class InputDetail extends StatefulWidget {

  final String appBarTitle;
  final Item item;

  ItemDetail(this.item, this.appBarTitle);

  @override
  State<StatefulWidget> createState(){

    return ItemDetailState(this.item, this.appBarTitle);
  }

}

class ItemDetailState extends State<ItemDetail> {

  static var _priorites = ['定期健康診断', '人間ドック'];

  DatabaseHelper helper = DatabaseHelper();
}
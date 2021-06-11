import 'package:flutter/material.dart';
import 'package:hu_health_care_mania/utils/database_helper.dart';
import 'package:hu_health_care_mania/models/item.dart';
import 'package:hu_health_care_mania/screens/input_detail.dart';
import 'package:sqflite/sqflite.dart';

class MenuList extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){

    return MenuListState();
  }
}

class MenuListState extends State<MenuList>{

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Item> itemList;
  int count =0;

  @override
  Widget build(BuildContext context){

    if (itemList == null){
      itemList =<Item>[];
      updateListView();
    }

    return Scaffold(

      appBar: AppBar(
        title: Text('HEALTHCARE MANIA'),
      ),

      body: getMenuListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('FAB clicked');
          navigateToDetail(Item(2,''), '新規登録');
        },

        tooltip: '新規登録',

        child:Icon(Icons.add),
      ),
    );
  }

  ListView getMenuListView(){

    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
            backgroundColor: getPriorityColor(this.itemList[position].priority),
              child: getPriorityIcon(this.itemList[position].priority),
            ),

            title: Text('受診日 : '+ this.itemList[position].on_the_day),

            subtitle: Text('更新日'+ this.itemList[position].date),


              onTap:(){
              debugPrint("ListTitle Tapped");
              navigateToDetail(this.itemList[position],'参照・訂正');
            },
          ),
        );
        },
    );
  }


  Color getPriorityColor(int priority){
    switch (priority) {
      case 1:
        //type = "定期健康診断";
        return Colors.red;
        break;
      case 2:
        //type = "人間ドック";
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;

    }
  }

  Icon getPriorityIcon(int priority){
    switch(priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Item item) async{

    int result = await databaseHelper.deleteItem(item.id);
    if (result != 0){
      _showSnackBar(context, '削除完了');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message){

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Item item, String height) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return InputDetail(item, height);
    }));

    if (result == true){
      updateListView();
    }
  }

void updateListView(){

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Item>> itemListFuture = databaseHelper.getItemList();
      itemListFuture.then((itemList){
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
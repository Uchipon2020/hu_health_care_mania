import 'package:hu_health_care_mania/models/item.dart';
import 'package:flutter/material.dart';
import 'package:hu_health_care_mania/utils/database_helper.dart';
import 'package:intl/intl.dart';

class InputDetail extends StatefulWidget {

  final String appBarTitle;
  final Item item;
  String formatted;

  InputDetail(this.item, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return InputDetailState(this.item, this.appBarTitle);
  }
}

class InputDetailState extends State<InputDetail> {

  static var _priorites = ['定期健康診断', '人間ドック'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Item item;

  TextEditingController onTheDayController = TextEditingController();

  InputDetailState(this.item, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    onTheDayController.text = item.on_the_day;

    return WillPopScope(
    //onWillPop: () => moveToLastScreen(),

      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(
              Icons.arrow_back),
              onPressed: (){
            moveToLastScreen();
          }),
        ),

        body: Padding(
            padding: EdgeInsets.only(top: 145.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                ListTile(title: DropdownButton(
                  items: _priorites.map((String dropDownStringItem){
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),);}).toList(),
                  style: textStyle,
                  value: getPriorityAsString(item.priority),
                  onChanged: (valueSelectedByUser){
                    setState((){
                      debugPrint('User selected $valueSelectedByUser');
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  }


                ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 10.0),

                  child: TextField(//受診日入力　カレンダー表示入力不可
                    controller: onTheDayController,
                    enabled: false,
                    onChanged: (value){
                      debugPrint('Something changed in description text field');
                      updateOTD();
                    },
                    decoration: InputDecoration(
                      labelText: '受診日',
                      labelStyle: textStyle,
                      icon: Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),
                  ),
                ),

                Padding (
                  padding: EdgeInsets.only(top:15.0, bottom:10.0),
                  child: Row (
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text('Save',textScaleFactor: 1.5,),
                            onPressed: (){
                              setState(() {
                                _save();
                              });
                            },
                          ),
                      ),

                      Container(width: 5.0,),

                      Expanded(child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Delete',textScaleFactor: 1.5,),
                        onPressed: (){
                          setState(() {
                            _delete();
                          });
                        },
                      ))
                    ],
                  )
                )
              ],
            ),
        ),
      ),
    );
  }

  // MOVE
  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  //CONVERT
  void updatePriorityAsInt(String value){
    switch (value){
      case '健康診断':
        item.priority = 1;
        break;
      case '人間ドック':
        item.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority = _priorites[0];
        break;
      case 2:
        priority = _priorites[1];
        break;
    }
    return priority;
  }

//UPDATE
  void updateOTD(){
    item.on_the_day = onTheDayController.text;
  }

  //SAVE
void _save() async {
    moveToLastScreen();
    item.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (item.id != null){
      result = await helper.updateItem(item);
          }else{
      result = await helper.insertItem(item);
    }
    if(result !=0){
      _showAlertDialog('status','save success!');
    }else {
      _showAlertDialog('status','Sorry error!!');
    }
  }

  //DELETE
  void _delete() async{
   moveToLastScreen();
   if (item.id == null){
     _showAlertDialog('status', 'Delete success!');
   return;}
   int result = await helper.deleteItem(item.id);
   if(result != 0){
     _showAlertDialog('Status', 'success');
   } else{
     _showAlertDialog('status', 'error');
   }
  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title:Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
    }
  }






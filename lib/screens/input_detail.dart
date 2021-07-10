import 'package:flutter/cupertino.dart';
import 'package:hu_health_care_mania/models/item.dart';
import 'package:flutter/material.dart';
import 'package:hu_health_care_mania/models/item.dart';
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

  static var _priorites = ['定期健康診断', '人間ドック', '雇入時健診', 'その他'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Item item;

  TextEditingController onTheDayController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  InputDetailState(this.item, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .subtitle1;
//コントローラーのセット
    onTheDayController.text = item.on_the_day;
    heightController.text = item.height;


    //メインエリアーーーーーーーーーーーーーーーーー
    return WillPopScope(
      //onWillPop: () => moveToLastScreen(),

      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(
              Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              }),
        ),

        /*
        select course--------------------------
        */
        body: Padding(
          padding: EdgeInsets.only(top: 145.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[

              ListTile(title: DropdownButton(
                  items: _priorites.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),);
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(item.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  }),),

              /*
                * calendar input-------------------------
                * */
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 10.0),

                child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _selectDate(context)
                          ;
                        },
                        icon: Icon(Icons.calendar_today_outlined),
                      ),
                      Expanded(
                        child: TextField( //受診日入力　カレンダー表示入力不可
                          controller: onTheDayController,
                          enabled: false,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in description text field');
                            updateOTD();
                          },
                          decoration: InputDecoration(
                            labelText: '受診日',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),

              /*
                * Height-------------------------
                * */
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 10.0),

                child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(
                              new FocusNode());
                          selectheight();
                        },
                        icon: Icon(Icons.accessibility),
                      ),
                      Expanded(
                        child: TextField(
                          controller: heightController,
                          textAlign: TextAlign.right,
                          //enabled: false,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in description text field');
                            updateHeight();
                          },
                          decoration: InputDecoration(
                            labelText: '身長',
                            labelStyle: textStyle,
                            suffix: Text(' cm'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),


              /*
                * Save & Delete---------------------------
                * */
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme
                              .of(context)
                              .primaryColorDark,
                          textColor: Theme
                              .of(context)
                              .primaryColorLight,
                          child: Text('Save', textScaleFactor: 1.5,),
                          onPressed: () {
                            setState(() {
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(child: RaisedButton(
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                        textColor: Theme
                            .of(context)
                            .primaryColorLight,
                        child: Text('Delete', textScaleFactor: 1.5,),
                        onPressed: () {
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

  /*
  * メソッドエリア
  * */
  //drum roll
  void selectheight(){
    final height_list = item.heightlist;
    final _pickerItems = height_list.map<Widget>((item) => Text(item)).toList();
    var selectedIndex = 5;

    showCupertinoModalPopup<void>(context: context,
      builder: (BuildContext context){
        return Container(
          height: 216,
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child:CupertinoPicker(
              itemExtent: 32,
              scrollController: FixedExtentScrollController(
                initialItem: 0,),
              backgroundColor: Colors.white,
              children: _pickerItems,
              onSelectedItemChanged: (int index){
                selectedIndex = index;
              },
            ),
          ),
        );
      },
    ).then((_){
      if(selectedIndex != null){
        heightController.value = TextEditingValue(text: height_list[selectedIndex]);
      }
    });
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
      case '雇入時健診':
        item.priority = 3;
        break;
      case 'その他':
        item.priority = 4;
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
      case 3:
        priority = _priorites[3];
        break;
      case 4:
        priority = _priorites[4];
        break;
    }
    return priority;
  }

  //UPDATE
  void updateOTD(){
    item.on_the_day = onTheDayController.text;
  }
  void updateHeight(){
    item.height = heightController.text;
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

  //Show Dialog
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

    //calender表示用メソッド
Future<void> _selectDate(BuildContext context) async{
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: new DateTime.now().add(new Duration(days:720))
    );
    if(selected != null){
      item.on_the_day =DateFormat.yMMMd().format(selected);
    setState(() => onTheDayController.text = item.on_the_day);
    debugPrint(
      '$onTheDayController.text');
    }
  }
}







import 'package:hu_health_care_mania/models/item.dart';
import 'package:path_provider/provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String itemTable = 'item_table'; //テーブル名
  String colId = 'id'; //id
  String colPriority = 'priority'; //優先順位
  // ignore: non_constant_identifier_names
  String colOn_the_day = 'on_the_day'; //受診日
  String colDate = 'date'; //更新日

  DatabaseHelper._createInstance();

  //特殊なコンストラクタ（初期設定）を指定する。インスタンスする際に、
  // 中身がNull出会った場合はデータベースを作成するという、
  // 単に数値セットだけでなく、条件分岐などのプログラムを走らせたいときに使う
  factory DatabaseHelper(){

    if (_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'items.db';

    var itemDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return itemDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    
    await db.execute('CREATE TABLE $itemTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '　$colOn_the_day TEXT,'
        ' $colPriority INTEGER'
        ' $colDate TEXT)');
  }
//データベースからすべてのオブジェクトを取得する
  Future<List<Map<String, dynamic>>> getItemMapList() async{
    Database db = await this.database;

    var result = await db.query(itemTable, orderBy: '$colPriority ASC');
    return result;
  }


  //オブジェクトのなかから、指定されたものを取り込む
  Future<int> insertItem(Item item) async{
    Database db = await this.database;
    var result = await db.insert(itemTable, item.toMap());
    return result;
  }


  //データベースを更新する
  Future<int> updateItem(Item item) async{
    Database db = await this.database;
    var result = await db.update(itemTable, item.toMap(), where: '$colId = ?', whereArgs: [item.id]);
    return result;
  }


  //データベースを削除する
  Future<int> deleteItem(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $itemTable WHERE $colId = $id');
    return result;
  }

  //データベースのオブジェクトの番号を取得する
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $itemTable');
    int result = Sqflite.firstIntValue(x);
    return result;
 }


 //マップリスト　と　アイテムリストをコンバートする？
  Future<List<Item>> getItemList() async {

    var itemMapList = await getItemMapList();//データベースから、MapItemを獲得
    int count = itemMapList.length;//テーブルのマップの数を数える

    Linst<Item> itemList = <Item>[];

    for (int = 0; i < count; i++){
      itemList.add(Item.fromMapObject(itemMapList[1]));
    }
    return itemList;
}
}






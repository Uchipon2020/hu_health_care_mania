
class Item{

  int _id; //id
  // ignore: non_constant_identifier_names
  String _on_the_day;  //受診日
  String _date;//更新日
  int _priority;//分類
  String _height;

  //測定値
  dynamic heightlist = ['210.0','209.9','209.8','209.7'];

//コンストラクタ（初期設定）２段階。ノーマルと、ID付きコンストラクタ
  Item(this._priority,[this._id, this._on_the_day, this._date, this._height]);
  Item.withId(this._id, this._priority,[this._on_the_day, this._date, this._height]);

  //getter & setter
  int get id => _id;
  String get on_the_day => _on_the_day;
  String get date => _date;
  int get priority => _priority;
  String get height => this._height;

  set on_the_day(String newOTD){
    if (newOTD.length <= 255){
      this._on_the_day = newOTD;
    }
  }
  set priority(int newPriority){
    if (newPriority >=1 && newPriority <=4){
      this._priority = newPriority;
    }
  }
  set date(String newDate){
    if (newDate.length <= 255){
      this._date = newDate;
    }
  }
    set height(String newHeight){
      if (newHeight.length <= 255){
        this._height = newHeight;
      }
    }

//Flutterには配列が無いので、マッピングのリストを作成
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if (id != null){map['id'] = _id;}
    map['on_the_day'] = _on_the_day;
    map['priority'] = _priority;
    map['data'] = _date;
    map['height'] = _height;
    return map;

  }

  Item.fromMapObject(Map<String, dynamic>map){
    this._id = map['id'];
    this._on_the_day = map['on_the_day'];
    this._priority = map['Priority'];
    this._date = map['date'];
    this._height = map['height'];
  }
}
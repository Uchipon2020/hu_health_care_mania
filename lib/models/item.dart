
class Item{

  int _id;
  // ignore: non_constant_identifier_names
  String _on_the_day;
  String _date;
  int _priority;

  Item(this._priority,[this._on_the_day, this._date]);
  Item.withId(this._id, this._priority,[this._on_the_day, this._date]);

  int get id => _id;
  String get on_the_day => _on_the_day;
  String get date => _date;
  int get priority => _priority;

  set on_the_day(String newOTD){
    if (newOTD.length <= 255){
      this._on_the_day = newOTD;
    }
  }
  set priority(int newPriority){
    if (newPriority >=1 && newPriority <=2){
      this._priority = newPriority;
    }
  }
  set date(String newDate){
    if (newDate.length <= 255){
      this._date = newDate;
    }
  }


  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();
    if (id != null){
      map['id'] = _id;
    }
    map['on_the_day'] = _on_the_day;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;

  }

  Item.fromMapObject(Map<String, dynamic>map){
    this._id = map['id'];
    this._on_the_day = map['on_the_day'];
    this._priority = map['Priority'];
    this._date = map['date'];
  }



}

class Item{

  int _id;
  String _on_the_day;
  int _priority;

  Item(this._priority,[this._id, this._on_the_day]);
  Item.withId(this._id, this._priority,[this._on_the_day]);

  int get id => _id;
  String get on_the_day => _on_the_day;
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

  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();
    if (id != null){
      map['id'] = _id;
    }
    map['on_the_day'] = _on_the_day;
    map['priority'] = _priority;
    return map;

  }

  Item.fromMapObject(Map<String, dynamic>map){
    this._id = map['id'];
    this._on_the_day = map['on_the_day'];
    this._priority = map['Priority'];
  }


}
class Note {
  int _id=0;
  int _priority=0;
  String _title="";
  String _description="";
  String _date="";

  Note(_priority, _title, _date,  [_description]);
  Note.witId(_id, _priority, _title, _date, [_description]);


  int get id => _id;

  String get date => _date;
  set date(String value) {
    _date = value;
  }

  String get description => _description;
  set description(String value) {
    if (value.length <= 255) {
      _description = value;
    }
  }

  String get title => _title;
  set title(String value) {
    if (value.length <= 255) {
      _description = value;
    }
  }

  int get priority => _priority;
  set priority(int value) {
    _priority = value;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(id != 0) {
      map['id'] = _id;
    }
    map['title']=_title;
    map['description']=_description;
    map['priority']=_priority;
    map['date']=_date;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map){
    _id=map['id'];
    _title=map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _date = map['date'];

  }
}

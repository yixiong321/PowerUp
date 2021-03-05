class Session{
  int _sessionID;
  int _numberOfClasses;
  String _startDate;
  String _dateTime;
  int _vacancy;
  int _classSize;
  List<String> _participantList;

  Session(this._sessionID, this._numberOfClasses, this._startDate,
      this._dateTime, this._vacancy, this._classSize, this._participantList);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'sessionID' : _sessionID,
      'numberOfClasses' : _numberOfClasses,
      'startDate' : _startDate,
      'dateTime' : _dateTime,
      'vacancy' : _vacancy,
      'classSize' : _classSize,
    };
    return map;
  }

  Session.fromMap(Map<String, dynamic> map){
    _sessionID = map['sessionID'];
    _numberOfClasses = map['numberOfClasses'];
    _startDate = map['startDate'];
    _dateTime = map['dateTime'];
    _vacancy = map['vacancy'];
    _classSize = map['classSize'];
  }

  int get sessionID => _sessionID;

  set sessionID(int value) {
    _sessionID = value;
  }

  int get numberOfClasses => _numberOfClasses;

  set numberOfClasses(int value) {
    _numberOfClasses = value;
  }

  String get startDate => _startDate;

  set startDate(String value) {
    _startDate = value;
  }

  String get dateTime => _dateTime;

  set dateTime(String value) {
    _dateTime = value;
  }

  int get vacancy => _vacancy;

  set vacancy(int value) {
    _vacancy = value;
  }

  int get classSize => _classSize;

  set classSize(int value) {
    _classSize = value;
  }

  List<String> get participantList => _participantList;

  set participantList(List<String> value) {
    _participantList = value;
  }
}
class Session{
  int _sessionID;
  String _startDate;
  String _dateTime;
  int _vacancy;
  int _classSize;
  List<String> participantList;
  //---------Constructors---------//
  Session.empty();
  Session(this._startDate, this._dateTime,this._vacancy, this._classSize);
  //---------Database---------//
  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
    "sessionID":_sessionID,
    "startDate":_startDate,
    "dateTime": _dateTime,
    "vacancy":_vacancy,
    "classSize": _classSize,
    //"participantList": participantList; in Register database
    };
    return map;
  }
  Session.fromMap(Map<String, dynamic> map) {
    _sessionID = map['sessionID'];
    _startDate = map['startDate'];
    _dateTime = map['dateTime'];
    _vacancy = map['vacancy'];
    _classSize = map['classSize'];
    //participantList in Register database
  }
  //---------getters and setters---------//
  int get sessionID => _sessionID;
  set sessionID(int value) {
    _sessionID = value;
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
  int get classSize => this._classSize;
  set classSize(int value) {
    _classSize = value;
  }
  List<String> get participantListTotal => this.participantList; //added Total at the back so that they r of different names from variable
  set participantListTotal(List<String> participantEmail) {
    participantList = participantEmail;
  }
  void addToParticipantList(String participantEmail){
    participantList.add(participantEmail);
    _vacancy--;
  }
  void removeFromParticipantList(String participantEmail){
    participantList.remove(participantEmail);
    _vacancy++;
  }
}
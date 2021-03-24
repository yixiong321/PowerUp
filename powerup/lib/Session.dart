class Session{
  int _sessionID;
  int _numberOfClasses;
  String _startDate;
  String _dateTime;
  int _vacancy;
  int classSize;

  int get sessionID => _sessionID;

  set sessionID(int value) {
    _sessionID = value;
  }

  List<String> participantList;

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
  }

}
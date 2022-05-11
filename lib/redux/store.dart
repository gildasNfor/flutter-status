class AppState {
  final String _date;
  final String _time;
  final bool _isPublicStatus;


  String get date => _date;
  String get time => _time;
   bool get isPublicStatus => _isPublicStatus;


  AppState(this._date, this._time, this._isPublicStatus);

  AppState.initialState() : _date = "", _time = "", _isPublicStatus = false;

}
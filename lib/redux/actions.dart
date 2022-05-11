class FetchTimeAndDateAction {
  final String _date;
  final String _time;
  final bool _isPublicStatus;

  String get date => _date;
  String get time => _time;
  bool get isPublicStatus => _isPublicStatus;

  FetchTimeAndDateAction(this._date, this._time, this._isPublicStatus);
}
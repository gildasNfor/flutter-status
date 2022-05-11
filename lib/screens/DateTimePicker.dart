import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../redux/actions.dart';
import '../redux/store.dart';

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late double _height;
  late double _width;

  late String _setTime, _setDate;

  static late String _hour, _minute, _time;

  static late String dateTime;

  static bool publicStatus = false;

  DateTime selectedDate = DateTime.now().add(const Duration(hours: 24));

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {

    var store = StoreProvider.of<AppState>(context);

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateTime = selectedDate.toString();
        print(dateTime);
        _dateController.text = DateFormat.yMd().format(selectedDate);
        store.dispatch(FetchTimeAndDateAction(DateFormat.yMd().format(selectedDate), store.state.time, store.state.isPublicStatus));
        print(DateFormat.yMd().format(selectedDate));
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    var store = StoreProvider.of<AppState>(context);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,

    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        print(selectedTime);
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        if (_minute.length == 1) _time = _hour + ' : 0' + _minute;
        else _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        // _timeController.text = formatDate(
        //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
        //     [hh, ':', nn, " ", am]).toString();
        // DateTime now = DateTime.now();
        print(_hour + ":" + _minute);
        store.dispatch(FetchTimeAndDateAction(store.state.date, _hour + ":" + _minute, store.state.isPublicStatus));

      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(selectedDate);
    dateTime = DateFormat.yMd().format(selectedDate);
    _timeController.text = DateFormat('HH:mm').format(DateTime.now());
    _time = DateFormat('HH:mm').format(DateTime.now());
    // _timeController.text = formatDate(
    //     DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
    //     [hh, ':', nn, " ", am]).toString();

    super.initState();
  }

  static String getTime() {
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Status Settings'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: _width,
        height: _height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(

                  margin: EdgeInsets.only(bottom: 140),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: publicStatus,
                        onChanged: (value) {
                          setState(() {
                            publicStatus = !publicStatus;
                            store.dispatch(FetchTimeAndDateAction(store.state.date, store.state.time, publicStatus));
                          });
                        },
                      ),
                      Text("Public status", style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),)
                    ],
                  ),
                ),
                Text(
                  'Delete Date',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                InkWell(

                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: _width / 1.7,
                    height: _height / 9,
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      onSaved: (val) {
                        _setDate = val!;
                      },
                      decoration: InputDecoration(
                          disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'Delete Time',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: _width / 1.7,
                    height: _height / 9,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,

                      onSaved: (val) {
                        _setTime = val!;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                          disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.all(5)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:shared_preferences/shared_preferences.dart';


Future<String> getServerAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('server')!;
    print("THE SERVER ADDRESS IS");
    print(stringValue);
    return stringValue;
}

int userNumber = 672840255;
// int userNumber = 652119040;
// int userNumber = 650581055;
// int userNumber = 673281857;

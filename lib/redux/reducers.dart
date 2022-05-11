import 'package:whatapp_clone_ui/redux/store.dart';

import 'actions.dart';

AppState reducer(AppState prev, dynamic action) {
  if (action is FetchTimeAndDateAction) {
    return AppState(action.date, action.time, action.isPublicStatus);
  } else {
    return prev;
  }
}
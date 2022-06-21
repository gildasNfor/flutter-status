

import 'dart:convert';

List<StatusPreviewModel> postFromJson(String str) =>
    List<StatusPreviewModel>.from(json.decode(str).map((x) => StatusPreviewModel.fromMap(x)));


class StatusPreviewModel {
  int userNumber;
  int numberOfStatus;
  String userName;
  String lastImageThumb;
  String lastStatusTime;
  StatusPreviewModel({required this.userNumber, required this.numberOfStatus, required this.lastImageThumb,required this.lastStatusTime,required this.userName});

  Map<String, dynamic> toMap() {
    return {
      "userNumber": userNumber,
      "userName": userName,
      "numberOfStatus": numberOfStatus,
      "lastImageThumb": lastImageThumb,
      "lastStatusTime": lastStatusTime,
    };
  }

  factory StatusPreviewModel.fromMap(Map<String, dynamic> json) {
    return StatusPreviewModel(
        userNumber: json['userNumber'],
        numberOfStatus: json['numberOfStatus'],
        userName: json['userName'],
        lastImageThumb: json['lastImageThumb'],
        lastStatusTime: json['lastStatusTime'],
    );
  }

  toString(){
    return userNumber.toString() + '/' + numberOfStatus.toString() + '/' +lastImageThumb+ '/' +lastStatusTime + '/' +userName;
  }
}
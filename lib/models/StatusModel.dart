

import 'dart:convert';

List<StatusModel> postFromJson(String str) =>
    List<StatusModel>.from(json.decode(str).map((x) => StatusModel.fromMap(x)));


class StatusModel {
  int userNumber;
  String postTime;
  String statusImageUrl;
  String statusVideoUrl;
  bool isPublicStatus;
  String statusText;
  String statusCaption;
  String disappearTime;
  String duration;
  StatusModel({required this.userNumber, required this.postTime, required this.statusImageUrl,required this.statusVideoUrl, required this.isPublicStatus, required this.statusText,required this.statusCaption, required this.disappearTime, required this.duration});

  Map<String, dynamic> toMap() {
    return {
      "userNumber": userNumber,
      "postTime": postTime,
      "statusImageUrl": statusImageUrl,
      "statusVideoUrl": statusVideoUrl,
      "isPublicStatus": isPublicStatus,
      "statusText": statusText,
      "statusCaption": statusCaption,
      "disappearTime": disappearTime,
      "duration": duration
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> json) {
    return StatusModel(
      userNumber: json['userNumber'],
        postTime: json['postTime'],
        statusImageUrl: json['statusImageUrl'],
        statusVideoUrl: json['statusVideoUrl'],
        isPublicStatus: json['isPublicStatus'],
        statusText: json['statusText'],
        statusCaption: json["statusCaption"],
        disappearTime: json['disappearTime'],
        duration: json['duration']
    );
  }
  //
  // toString(){
  //   return userNumber.toString() + '/' + numberOfStatus.toString() + '/' +lastImageThumb+ '/' +lastStatusTime;
  // }
}
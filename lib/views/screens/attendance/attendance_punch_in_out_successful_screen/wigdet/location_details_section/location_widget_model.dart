import 'package:flutter/material.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/lanch_helper.dart';
import 'package:vlr/services/theme.dart';

class LocationWidgetModel {
  final Color color;
  final String? title;
  final String? lat;
  final String? lng;
  final Function() onTap;

  LocationWidgetModel(
      {required this.color,
      required this.title,
      required this.lat,
      required this.lng,
      required this.onTap});
}

List<LocationWidgetModel> locationWidgetModelList(
        {required AttendanceController attendanceController}) =>
    [
      LocationWidgetModel(
          color: green2,
          title: "Punch In Location",
          lat: attendanceController.attendanceModel?.checkInLat ?? "",
          lng: attendanceController.attendanceModel?.checkInLng ?? "",
          onTap: () {
            LaunchHelper.openGoogleMap(
              lat: attendanceController.attendanceModel?.checkInLat ?? "",
              lng: attendanceController.attendanceModel?.checkInLng ?? "",
            );
          }),
      LocationWidgetModel(
          color: red1,
          title: "Punch out Location",
          lat: attendanceController.attendanceModel?.checkOutLat ?? "",
          lng: attendanceController.attendanceModel?.checkOutLng ?? "",
          onTap: () {
            LaunchHelper.openGoogleMap(
              lat: attendanceController.attendanceModel?.checkOutLat ?? "",
              lng: attendanceController.attendanceModel?.checkOutLng ?? "",
            );
          })
    ];

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/models/scheduledride.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduledRideController extends ChangeNotifier {
  bool isloading = false;
  ScheduledRides? scheduledride;

  Future<void> getrides({required BuildContext context}) async {
    isloading = true;
    scheduledride = null;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    AppRepository()
        .getscheduledride(
      accesstoken: prefs.getString(
        Strings.accesstoken,
      )!,
      user: prefs.getString(
        Strings.userid,
      )!,
    )
        .then((value) {
      print("Value is $value");
      if (value == null) {
        // isloading = false;
        Loader.hide();
      } else if (value["code"] == 200) {
        scheduledride = ScheduledRides.fromJson(
          value,
        );
        isloading = false;
        Loader.hide();
        notifyListeners();
      } else if (value["code"] == 401) {
        Loader.hide();
        notifyListeners();
      } else if (value["code"] == 201) {
        Loader.hide();
        isloading = false;
        //      context.showSnackBar(context, msg: value["message"]);
        notifyListeners();
      } else {
        Loader.hide();
        notifyListeners();
      }
    });
  }

  Future<void> cancelride({
    required BuildContext context,
    required String rideid,
  }) async {
    isloading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    AppRepository()
        .cancelScheduleride(
      booking_number: rideid,
      accesstoken: prefs.getString(
        Strings.accesstoken,
      )!,
      user: prefs.getString(
        Strings.userid,
      )!,
    )
        .then((value) {
      print("Value is $value");
      if (value == null) {
        // isloading = false;
        Loader.hide();
      }
      if (value["code"] == 200) {
        context.showSnackBar(context, msg: value["message"]);

        isloading = false;
        scheduledride = null;
        Loader.hide();
        Navigator.pop(context);

        getrides(context: context);
        notifyListeners();
      } else if (value["code"] == 401) {
        Loader.hide();
        notifyListeners();
      } else if (value["code"] == 201) {
        Loader.hide();
        isloading = false;
        context.showSnackBar(context, msg: value["message"]);
        notifyListeners();
      } else {
        Loader.hide();
        notifyListeners();
      }
    });
  }
}

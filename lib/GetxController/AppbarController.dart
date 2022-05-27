import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppbarController extends GetxController{
  String time = "";
  String date = "";
  Timer? timer;

  @override
  void onInit() {
    time = DateFormat("hh:mm:ss aa").format(DateTime.now());
    date = DateFormat("dd MMM, yyyy").format(DateTime.now());
    super.onInit();
    startTime();
  }

  @override
  void dispose() {
    if(timer != null){
      timer!.cancel();
    }
    super.dispose();
  }

  void startTime() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      time = DateFormat("hh:mm:ss aa").format(DateTime.now());
      date = DateFormat("dd MMM, yyyy").format(DateTime.now());
      update(["0"]);
      notifyChildrens();
    });
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../AppConstants/Constants.dart';

class LocaleController extends GetxController{
  String locale = english;
  var box = GetStorage();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLocale();
  }

  void getLocale() async {
    String? lang = box.read(language);
    if(lang == null){
      locale = english;
      await box.write(language, english);
      Locale l = Locale(english);
      Get.updateLocale(l);
    }else{
      locale = lang;
      Locale l = Locale(lang);
      Get.updateLocale(l);
    }
    // update(["0"]);
    // notifyChildrens();
  }

  void updateLocale(lang) async {
    locale = lang;
    await box.write(language, lang);
    Locale l = Locale(lang);
    Get.updateLocale(l);
    update(["0"]);
    notifyChildrens();
  }

  void updateLoc() async {
    Locale l = Locale(locale);
    Get.updateLocale(l);
    update(["0"]);
    notifyChildrens();
  }

}
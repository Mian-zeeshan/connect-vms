import 'dart:async';
import 'dart:convert';

import 'package:connect_vms/AppConstants/Constants.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:connect_vms/Views/auth_screens/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../Models/UserModel.dart';
import '../entry_screens/EntryScreen.dart';
import '../exit_screens/ExitSearchScreen.dart';
import '../home_screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>{
  ThemeController theme = Get.find();
  var utils = AppUtils();
  var box = GetStorage();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer)  async {
      timer.cancel();
      var value = await box.read(currentUser);
      if(value != null){
        UserModel userModel = UserModel.fromJson(jsonDecode(jsonEncode(value)));
        if(userModel.status == 200) {
          await box.write(currentUser, userModel.toJson());
          Get.offAll(() => HomeScreen(userModel.gateType??"hybrid"));
        }
      }else {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: theme.mainColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: theme.mainColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Connect VMS", style: utils.xxLHeadingStyle(theme.whiteColor)),
              SizedBox(height: 12,),
              Text("A Project of Connect Solutions", style: utils.smallLabelStyle(theme.whiteColor.withOpacity(0.5)),),
              SizedBox(height: 12,),
              SpinKitDancingSquare(color: theme.whiteColor,)
            ],
          ),
        ),
      ),
    );
  }

}
import 'dart:convert';

import 'package:connect_vms/AppConstants/Constants.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/Models/UserModel.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:connect_vms/Views/entry_screens/EntryScreen.dart';
import 'package:connect_vms/Views/exit_screens/ExitSearchScreen.dart';
import 'package:connect_vms/Views/home_screens/HomeScreen.dart';
import 'package:connect_vms/services/AuthApis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{
  ThemeController theme = Get.find();

  var utils = AppUtils();

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var isSecure = true;
  var box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: theme.mainColor,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height-20,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [theme.mainColor.withOpacity(0.3), theme.mainColor.withOpacity(0.5), theme.mainColor.withOpacity(0.8), theme.mainColor], begin: Alignment.bottomCenter)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Get.width,
                  height: Get.height * 0.3,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/logo.png", fit: BoxFit.contain, width: 100.w,),
                      SizedBox(height: 12.h,),
                      Text("Connect Visitor Management System", style: utils.smallLabelStyle(theme.whiteColor),)
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  margin: EdgeInsets.symmetric(horizontal: Get.width*0.2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.whiteColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.mainColor,
                        ),
                        child: Icon(CupertinoIcons.person_2, color: theme.whiteColor, size: 32,),
                      ),
                      SizedBox(height: 30.h,),
                      Container(
                        width: Get.width,
                        child: utils.textField(theme.whiteColor, CupertinoIcons.envelope, theme.mainColor, null, null, theme.blackColor, "Email", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, false, usernameController),
                      ),
                      SizedBox(height: 12.h,),
                      Container(
                        width: Get.width,
                        child: utils.textField(theme.whiteColor, CupertinoIcons.lock, theme.mainColor, isSecure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, theme.mainColor, theme.blackColor, "Password", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, isSecure, passwordController, onClickSuffix: (){
                          setState(() {
                            isSecure = !isSecure;
                          });
                        }),
                      ),
                      SizedBox(height: 30.h,),
                      utils.button(theme.mainColor, "LOG IN", theme.whiteColor, theme.mainColor, 1.0, (){
                        if(usernameController.text.isEmpty){
                          Get.snackbar("Error", "Email is required!");
                          return;
                        }else if(!usernameController.text.toString().trim().isEmail){
                          Get.snackbar("Error", "Email is invalid!");
                          return;
                        }else if(passwordController.text.isEmpty){
                          Get.snackbar("Error", "Password is required!");
                          return;
                        }
                        loginUser();
                      }, secondaryColor: theme.secondaryColor),
                      SizedBox(height: 30.h,),
                    ],
                  ),
                ),
                SizedBox(height: 30.h,),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text("Privacy Policy", style: utils.smallLabelStyleUnderline(theme.blackColor),textAlign: TextAlign.center,)),
                          Expanded(child: Text("Terms & Conditions", style: utils.smallLabelStyleUnderline(theme.blackColor),textAlign: TextAlign.center,)),
                          Expanded(child: Text("Contact Us", style: utils.smallLabelStyleUnderline(theme.blackColor),textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    EasyLoading.show(status: "Logging in...");
    AuthApis authApis = AuthApis();

    var data = {
      "email" : usernameController.text.toString().trim(),
      "password" : passwordController.text.toString()
    };
    var response = await authApis.login(data);
    EasyLoading.dismiss();

    print(response.body);
    print(response.statusCode);

    if(response.statusCode == 201){
      UserModel userModel = UserModel.fromJson(jsonDecode(jsonEncode(response.body)));
      if(userModel.status == 200) {
        await box.write(currentUser, userModel.toJson());
        Get.offAll(() => HomeScreen(userModel.gateType??"hybrid"));
      }else{
        var message = "Something went wrong. Please check your internet connect and try again.";
        try{
          message = jsonDecode(jsonEncode(response.body))["message"];
        }catch(e){
        }
        utils.showAlert(CupertinoIcons.info, theme.redColor, "Error Login", "${message}", "Try again", "Close", (){
          Get.back();
          loginUser();
        }, (){
          Get.back();
        });
      }
    }else{
      var message = "Something went wrong. Please check your internet connect and try again.";
      try{
        message = jsonDecode(jsonEncode(response.body))["message"];
      }catch(e){
      }
      utils.showAlert(CupertinoIcons.info, theme.redColor, "Error Login", "${message}", "Try again", "Close", (){
        Get.back();
        loginUser();
      }, (){
        Get.back();
      });
    }

  }

}
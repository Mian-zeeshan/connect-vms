import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/GetxController/UserController.dart';
import 'package:connect_vms/GetxController/VehicleController.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:connect_vms/Views/entry_screens/EntryScreen.dart';
import 'package:connect_vms/Views/exit_screens/ExitSearchScreen.dart';
import 'package:connect_vms/Widgets/home/HomeAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget{
  var gateType = "hybrid";
  HomeScreen(this.gateType);
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  ThemeController theme = Get.find();
  var utils = AppUtils();
  UserController userController = Get.put(UserController());
  VehicleController vehicleController = Get.put(VehicleController());

  @override
  void initState() {
    goToScreen();
    super.initState();
  }

  goToScreen() async {
    if(widget.gateType.toLowerCase() == "in") {
      EasyLoading.show(status: "Redirecting....");
      await Future.delayed(Duration(seconds: 2));
      EasyLoading.dismiss();
      await Get.to(() => EntryScreen());
      goToScreen();
    }else if(widget.gateType.toLowerCase() == "out") {
      EasyLoading.show(status: "Redirecting....");
      await Future.delayed(Duration(seconds: 2));
      EasyLoading.dismiss();
      await Get.to(() => ExitSearchScreen());
      goToScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(id:"0",builder: (themeController){
      theme = themeController;

      var firstPartEntry = InkWell(
        onTap: (){
          Get.to(() =>EntryScreen());
        },
        child: Container(
          height: Get.height * 0.4,
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.greenColor.withOpacity(0.4)
          ),
          child: Center(
            child: Container(
              height: Get.height,
              width: Get.width,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.greenColor.withOpacity(0.7)
              ),
              child: Center(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.greenColor
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("ENTRY", style: utils.xxLHeadingStyle(theme.whiteColor),),
                      SizedBox(height: 12.h,),
                      Image.asset("assets/images/parking.png", width: Get.width * 0.2, color: theme.whiteColor,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      var secondPartExit = InkWell(
        onTap: (){
          Get.to(()=> ExitSearchScreen());
        },
        child: Container(
          height: Get.height * 0.4,
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.redColor.withOpacity(0.4)
          ),
          child: Center(
            child: Container(
              height: Get.height,
              width: Get.width,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.redColor.withOpacity(0.7)
              ),
              child: Center(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.redColor
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Exit", style: utils.xxLHeadingStyle(theme.whiteColor),),
                      SizedBox(height: 12.h,),
                      Image.asset("assets/images/exit.png", width: Get.width * 0.2, color: theme.whiteColor,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: theme.mainColor,
            elevation: 0,
          ),
        ),
        body: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBar(false, isExist: null,),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      firstPartEntry,
                      SizedBox(height: 20.h,),
                      secondPartExit
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      );
    });
  }

}
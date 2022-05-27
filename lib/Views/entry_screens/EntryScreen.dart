import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:connect_vms/AppConstants/Constants.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/GetxController/UserController.dart';
import 'package:connect_vms/Models/VehicleEntryModel.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:connect_vms/Views/auth_screens/LoginScreen.dart';
import 'package:connect_vms/Views/entry_screens/VichecleEntryScreen.dart';
import 'package:connect_vms/Widgets/home/HomeAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../GetxController/VehicleController.dart';

class EntryScreen extends StatefulWidget{
  @override
  _EntryScreen createState() => _EntryScreen();
}

class _EntryScreen extends State<EntryScreen>{
  var utils = AppUtils();
  ThemeController theme = Get.find();
  VehicleController vController = Get.find();
  //var carTypes = ["Car / Jeep", "Van", "Mini Bus", "Pickup / Loader", "Truck / Trailer", "Bus", "Bike", "Walk-In"];
  //var carTypesImages = ["car.png","van.png","minibus.png","loader.png","truck.png","bus.png","bike.png","walk.png"];
  var colors = [Colors.amber, Colors.blue, Colors.red, Colors.teal, Colors.brown, Colors.deepPurple, Colors.blueGrey, Colors.lightGreen, Colors.black54, Colors.teal, Colors.deepPurple,Colors.amber, Colors.blue, Colors.red, Colors.teal, Colors.brown, Colors.deepPurple, Colors.blueGrey, Colors.lightGreen, Colors.black54, Colors.teal, Colors.deepPurple,Colors.amber, Colors.blue, Colors.red, Colors.teal, Colors.brown, Colors.deepPurple, Colors.blueGrey, Colors.lightGreen, Colors.black54, Colors.teal, Colors.deepPurple,Colors.amber, Colors.blue, Colors.red, Colors.teal, Colors.brown, Colors.deepPurple, Colors.blueGrey, Colors.lightGreen, Colors.black54, Colors.teal, Colors.deepPurple,];
  var box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(id:"0", builder: (themeController){
      theme = themeController;
      return GetBuilder<UserController>(id: "0", builder: (userController){
        return Scaffold(
          backgroundColor: theme.whiteColor,
          floatingActionButton: InkWell(
            onTap: (){
              utils.showAlert(CupertinoIcons.square_arrow_left, theme.redColor, "Logout", "Do you really want to logout?", "Logout", "Cancel", () async {
                await box.remove(currentUser);
                Get.offAll(()=> LoginScreen());
              }, (){
                Get.back();
              });
            },
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.mainColor
              ),
              child: Center(
                child: Icon(CupertinoIcons.square_arrow_left, color: theme.whiteColor, size: 24,),
              ),
            ),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: theme.mainColor,
              elevation: 0,
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/bg.jpeg", opacity: AlwaysStoppedAnimation<double>(0.3),)
                    ],
                  ),
                ),
                Container(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeAppBar(userController.userModel != null ? (userController.userModel!.gateType??"hybrid").toLowerCase() == "hybrid" ? true : false : false),
                      Expanded(child: Container(
                        width: Get.width,
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                        child: SingleChildScrollView(
                          child: Container(
                            width: Get.width,
                            child: GetBuilder<VehicleController>(id: "0", builder: (vehicleController){
                              return vehicleController.isLoadingVehicles ? vehicleController.vehicleTypeModel.data.length > 0 ? Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  for(var i = 0 ; i < vehicleController.vehicleTypeModel.data.length; i++)
                                    carCards(vehicleController.vehicleTypeModel.data[i].vehicletypeName??"", vehicleController.vehicleTypeModel.data[i].vehicleTypeIcon??"", colors[i], () async{
                                      VehicleEntryModel entryModel = VehicleEntryModel(enterTime: "${DateFormat("yyyy-MM-dd hh:mm:ss aa").format(DateTime.now())}", visitLocationID: "", vehicleTypeID: vehicleController.vehicleTypeModel.data[i].vehicletypeId??"0", driverName: "", vehicleData: []);
                                      Get.to(()=> VihecleEntryScreen(entryModel));
                                    }),
                                ],
                              ) : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 50.h,),
                                  Icon(CupertinoIcons.info, color: theme.redColor, size: 52.w,),
                                  SizedBox(height: 12.h,),
                                  Text("No Car Types available at the moment.",style: utils.labelStyle(theme.blackColor.withOpacity(0.6)),),
                                  SizedBox(height: 12.h,),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.w),
                                      color: theme.mainColor
                                    ),
                                    child: TextButton(
                                      onPressed: (){
                                        vehicleController.GetVehicles(mounted: true);
                                      },
                                      child: Text("Reload", style: utils.labelStyle(theme.whiteColor),),
                                    ),
                                  )
                                ],
                              ) : Container(
                                width: Get.width,
                                height: Get.height*0.9,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(color: theme.mainColor,)
                                  ],
                                ),
                              );
                            },),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                    bottom: 20,
                    child: InkWell(
                  onTap: (){
                    vController.GetVehicles(mounted: true);
                    vController.GetVisitPlaces();
                    vController.GetCameras();
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.mainColor
                    ),
                    child: Center(
                      child: Icon(CupertinoIcons.refresh, color: theme.whiteColor, size: 24,),
                    ),
                  ),
                ))
              ],
            ),
          ),
        );
      });
    });
  }

  carCards(String name, String image,Color color, onPress){
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 130.w,
        height: 130.w,
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          color: color.withOpacity(1)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name, style: utils.boldLabelStyle(theme.whiteColor),),
            SizedBox(height: 4.h,),
            Image.memory(base64Decode(image.split(',').last), color: theme.whiteColor, width: 46.w,)
          ],
        ),
      ),
    );
  }


  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
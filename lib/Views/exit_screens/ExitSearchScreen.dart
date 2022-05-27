import 'dart:io';

import 'package:cnic_scanner/cnic_scanner.dart';
import 'package:cnic_scanner/model/cnic_model.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/GetxController/UserController.dart';
import 'package:connect_vms/Models/ExitVehicleModel.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:connect_vms/Views/exit_screens/ExitDetailScreen.dart';
import 'package:connect_vms/Widgets/home/HomeAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../AppConstants/Constants.dart';
import '../../GetxController/VehicleController.dart';
import '../auth_screens/LoginScreen.dart';
import '../scanner_screen/ScanQRScreen.dart';

class ExitSearchScreen extends StatefulWidget{
  @override
  _ExitSearchScreen createState() => _ExitSearchScreen();
}

class _ExitSearchScreen extends State<ExitSearchScreen>{
  var utils = AppUtils();
  ThemeController theme = Get.find();

  var cnicController = TextEditingController();
  var rfidController = TextEditingController();
  var plateController = TextEditingController();
  var box = GetStorage();
  VehicleController vController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(id:"0", builder: (themeController){
      theme = themeController;
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
        body: GetBuilder<UserController>(id: "0", builder: (userController){
          return SafeArea(
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
                      HomeAppBar(userController.userModel != null ? (userController.userModel!.gateType??"hybrid").toLowerCase() == "hybrid" ? true : false : false, isExist: true,),
                      Expanded(child: Container(
                        width: Get.width,
                        child: SingleChildScrollView(
                          child: Container(
                              width: Get.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Lottie.asset("assets/images/car_ani.json"),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Search By CNIC", style: utils.boldLabelStyle(theme.blackColor.withOpacity(0.8)),),
                                        SizedBox(height: 8.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(child: utils.textField(theme.whiteColor, CupertinoIcons.creditcard, theme.mainColor, CupertinoIcons.square_stack_3d_down_right_fill, theme.mainColor, theme.blackColor, "CNIC", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, false, cnicController, onClickSuffix: () async {
                                              EasyLoading.show(status: "Fetching Detail");
                                              try {
                                                CnicModel result = await CnicScanner()
                                                    .scanImage(
                                                    imageSource: ImageSource
                                                        .camera);
                                                EasyLoading.dismiss();
                                                cnicController.text = result.cnicNumber;
                                                setState(() {
                                                });
                                              }catch(e){
                                                EasyLoading.dismiss();
                                                Get.snackbar("Error", "Rough Image of Card.");
                                              }
                                            }),),
                                            SizedBox(width: 12.w,),
                                            InkWell(
                                              onTap: () async {
                                                if(cnicController.text.isEmpty){
                                                  Get.snackbar("Error", "Enter the CNIC first");
                                                  return;
                                                }else if(!cnicController.text.contains("-")){
                                                  Get.snackbar("Error", "Invalid CNIC must include\"-\"");
                                                  return;
                                                }else if(cnicController.text.length < 14){
                                                  Get.snackbar("Error", "Invalid CNIC");
                                                  return;
                                                }
                                                EasyLoading.show(status: "Searching...");
                                                ExitVehicleModel? exitModel = await vController.getVehicleById(cnicController.text, "", "");
                                                EasyLoading.dismiss();
                                                if(exitModel != null && exitModel.status == 200) {
                                                  Get.to(() =>
                                                      ExitDetailScreen(exitModel));
                                                }else{
                                                  Get.snackbar("Error", "Either there is no vehicle for this record or internet not connected!");
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: theme.mainColor
                                                ),
                                                child: Text("Search", style: utils.labelStyle(theme.whiteColor),),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 20.h,),
                                        Text("Search By RFID", style: utils.boldLabelStyle(theme.blackColor.withOpacity(0.8)),),
                                        SizedBox(height: 8.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(child: utils.textField(theme.whiteColor, CupertinoIcons.creditcard, theme.mainColor, CupertinoIcons.square_stack_3d_down_right_fill, theme.mainColor, theme.blackColor, "RFID", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, false, rfidController, onClickSuffix: () async {
                                              await Get.to(()=> ScanQRScreen());
                                              setState(() {
                                                rfidController.text = qrCode;
                                              });
                                            }),),
                                            SizedBox(width: 12.w,),
                                            InkWell(
                                              onTap: () async {
                                                if(rfidController.text.isEmpty){
                                                  Get.snackbar("Error", "Enter the RFID first");
                                                  return;
                                                }
                                                EasyLoading.show(status: "Searching...");
                                                ExitVehicleModel? exitModel = await vController.getVehicleById("", rfidController.text, "");
                                                EasyLoading.dismiss();
                                                if(exitModel != null && exitModel.status == 200) {
                                                  Get.to(() =>
                                                      ExitDetailScreen(exitModel));
                                                }else{
                                                  Get.snackbar("Error", "Either there is no vehicle for this record or internet not connected!");
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: theme.mainColor
                                                ),
                                                child: Text("Search", style: utils.labelStyle(theme.whiteColor),),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 20.h,),
                                        Text("Search By Plate No.", style: utils.boldLabelStyle(theme.blackColor.withOpacity(0.8)),),
                                        SizedBox(height: 8.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(child: utils.textField(theme.whiteColor, CupertinoIcons.creditcard, theme.mainColor, CupertinoIcons.square_stack_3d_down_right_fill, theme.mainColor, theme.blackColor, "Plate No.", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, false, plateController, onClickSuffix: () async {
                                            }),),
                                            SizedBox(width: 12.w,),
                                            InkWell(
                                              onTap: () async {
                                                if(plateController.text.isEmpty){
                                                  Get.snackbar("Error", "Enter the RFID first");
                                                  return;
                                                }
                                                EasyLoading.show(status: "Searching...");
                                                ExitVehicleModel? exitModel = await vController.getVehicleById("", "", plateController.text);
                                                EasyLoading.dismiss();
                                                if(exitModel != null && exitModel.status == 200) {
                                                  Get.to(() =>
                                                      ExitDetailScreen(exitModel));
                                                }else{
                                                  Get.snackbar("Error", "Either there is no vehicle for this record or internet not connected!");
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: theme.mainColor
                                                ),
                                                child: Text("Search", style: utils.labelStyle(theme.whiteColor),),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 50.h,),
                                ],
                              )
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
          );
        },),
      );
    });
  }
}
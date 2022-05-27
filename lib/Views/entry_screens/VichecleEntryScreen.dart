import 'dart:convert';
import 'dart:io';

import 'package:connect_vms/AppConstants/Constants.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/GetxController/VehicleController.dart';
import 'package:connect_vms/Models/VehicleEntryModel.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:connect_vms/Views/entry_screens/CNICScreen.dart';
import 'package:connect_vms/Views/ip_camera_screens/IPCameraScreen.dart';
import 'package:connect_vms/Views/scanner_screen/ScanQRScreen.dart';
import 'package:connect_vms/Widgets/home/HomeAppBar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../Models/VehicleDataModel.dart';

class VihecleEntryScreen extends StatefulWidget{
  VehicleEntryModel entryModel;
  VihecleEntryScreen(this.entryModel);
  @override
  _VihecleEntryScreen createState() => _VihecleEntryScreen();
}

class _VihecleEntryScreen extends State<VihecleEntryScreen>{
  var utils = AppUtils();
  ThemeController theme = Get.find();

  var plateNoController = TextEditingController();
  var rfIdController = TextEditingController();

  ImagePicker _picker = ImagePicker();
  File? _image;
  VehicleController vehicleController = Get.find();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(id:"0", builder: (themeController){
      theme = themeController;
      return Scaffold(
        backgroundColor: theme.whiteColor,
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
                    HomeAppBar(true),
                    Expanded(child: Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                      child: SingleChildScrollView(
                        child: Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DottedBorder(
                                  color: theme.mainColor.withOpacity(0.4),
                                  radius: Radius.circular(12.w),
                                  borderType: BorderType.RRect,
                                  strokeWidth: 2,
                                  strokeCap: StrokeCap.butt,
                                  child: Container(
                                    width: Get.height * 0.2,
                                    child: AspectRatio(
                                      aspectRatio: 1/1,
                                      child: Container(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.w),
                                        ),
                                        child: _image == null ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_photo_alternate_outlined, color: theme.blackColor.withOpacity(0.2), size: 96.w,),
                                            SizedBox(height: 8.h,),
                                            InkWell(
                                              onTap: (){
                                                showBottomCameraSheet();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.w),
                                                  color: theme.mainColor
                                                ),
                                                child: Text("Take Image", style: utils.boldLabelStyle(theme.whiteColor),),
                                              ),
                                            )
                                          ],
                                        ) :
                                        Stack(
                                          children: [
                                            Container(
                                                width: Get.width,
                                                height: Get.height,
                                                child: Image.file(_image!, fit: BoxFit.cover,)
                                            ),
                                            Positioned(
                                              bottom: 2.w,
                                                left: 2.w,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    showBottomCameraSheet();
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.w),
                                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: theme.whiteColor.withOpacity(0.4),
                                                    ),
                                                    child: Wrap(
                                                      alignment: WrapAlignment.center,
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      children: [
                                                        Icon(CupertinoIcons.refresh, color: theme.blackColor, size: 20,),
                                                        SizedBox(width: 6.w,),
                                                        Text("Re-Take", style: utils.smallLabelStyle(theme.blackColor),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ),
                                            /*Positioned(
                                              bottom: 2.w,
                                                right: 2.w,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      _image = null;
                                                    });
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.w),
                                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: theme.redColor.withOpacity(0.6),
                                                    ),
                                                    child: Wrap(
                                                      alignment: WrapAlignment.center,
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      children: [
                                                        Icon(CupertinoIcons.delete, color: theme.whiteColor, size: 20,),
                                                        SizedBox(width: 6.w,),
                                                        Text("Delete", style: utils.smallLabelStyle(theme.whiteColor),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 12.h,),
                              Container(
                                width: Get.width,
                                height: 1.h,
                                color: theme.grayColor,
                              ),
                              SizedBox(height: 12.h,),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Vehicle Type", style: utils.boldLabelStyle(theme.blackColor),),
                                        SizedBox(height: 8.h,),
                                        Text("${vehicleController.getVehicleFromType(widget.entryModel.vehicleTypeID)}", style: utils.boldLabelStyle(theme.greenColor),),
                                      ],
                                    )),
                                    Container(
                                      width: 1,
                                      color: theme.grayColor,
                                    ),
                                    Expanded(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Entry Time", style: utils.boldLabelStyle(theme.blackColor),),
                                        SizedBox(height: 8.h,),
                                        Text("${DateFormat("dd MMM, yyyy hh:mm:ss aa").format(DateFormat("yyyy-MM-dd hh:mm:ss aa").parse(widget.entryModel.enterTime))}", style: utils.labelStyle(theme.secondaryColor),),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h,),
                              Container(
                                width: Get.width,
                                height: 1.h,
                                color: theme.grayColor,
                              ),
                              SizedBox(height: 12.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Plate No.", style: utils.smallLabelStyle(theme.blackColor.withOpacity(0.8)),),
                                      SizedBox(height: 8.h,),
                                      utils.textField(theme.whiteColor, CupertinoIcons.tag, theme.mainColor, null, null, theme.blackColor, "Plate No.", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, false, plateNoController)
                                    ],
                                  )),
                                  SizedBox(width: 12.w,),
                                  Expanded(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("RFID Card", style: utils.smallLabelStyle(theme.blackColor.withOpacity(0.8)),),
                                      SizedBox(height: 8.h,),
                                      utils.textField(theme.whiteColor, CupertinoIcons.creditcard, theme.mainColor, CupertinoIcons.square_stack_3d_down_right_fill, theme.mainColor, theme.blackColor, "Scan RFID Card", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, false, rfIdController, onClickSuffix: () async {
                                        await Get.to(()=> ScanQRScreen());
                                        setState(() {
                                          rfIdController.text = qrCode;
                                        });
                                      })
                                    ],
                                  )),
                                ],
                              ),
                              SizedBox(height: 20.h,),
                              utils.button(theme.mainColor, "Next", theme.whiteColor, theme.mainColor, 1.0, (){
                                if(plateNoController.text.isEmpty){
                                  Get.snackbar("Error", "Enter the plate no.");
                                  return;
                                }else if(_image  == null){
                                  Get.snackbar("Error", "Take driver Image First");
                                  return;
                                }

                                widget.entryModel.vehicleNumber = plateNoController.text;
                                widget.entryModel.rFIDCardNo = rfIdController.text.isEmpty ? "N/A" : rfIdController.text.toString();
                                Get.to(()=> CNICScreen(widget.entryModel));
                              })
                            ],
                          )
                        ),
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  carCards(String name, String image,Color color){
    return Container(
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
          Image.asset("assets/images/$image", width: 46.w, color: theme.whiteColor)
        ],
      ),
    );
  }

  void showBottomCameraSheet() {
    Get.dialog(
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20.w), topLeft: Radius.circular(20.w)),
                color: theme.whiteColor
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(onTap: (){Get.back();}, child: Icon(CupertinoIcons.arrow_left, color: theme.blackColor,size: 24,)),
                      SizedBox(width: 12.w,),
                      Text("Available Cameras", style: utils.headingStyle(theme.blackColor),),
                    ],
                  ),
                  SizedBox(height: 12.w,),
                  Container(
                    width: Get.width,
                    height: 1,
                    color: theme.grayColor,
                  ),
                  SizedBox(height: 12.w,),
                  GestureDetector(
                    onTap: (){
                      getImage();
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.camera, color: theme.blackColor, size: 20,),
                        SizedBox(width: 12.w,),
                        Text("Device Camera", style: utils.smallLabelStyle(theme.blackColor),)
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h,),
                  Container(
                    width: Get.width,
                    height: 1,
                    color: theme.grayColor,
                  ),
                  GetBuilder<VehicleController>(id:"0",builder: (vehicleController){
                    print(vehicleController.devicesModel.toJson());
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for(var i = 0 ; i < vehicleController.devicesModel.data.length; i++)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.h,),
                              GestureDetector(
                                onTap: () async {
                                  Get.back();
                                  await Get.to(()=> IpCameraScreen(vehicleController.devicesModel.data[i].deviceIp));
                                  if(ipImageGlobal != null){
                                    _image = await utils.convertImage(ipImageGlobal!);
                                  }

                                  setState(() {
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.map_pin_ellipse, color: theme.blackColor, size: 20,),
                                    SizedBox(width: 12.w,),
                                    Text("${vehicleController.devicesModel.data[i].deviceName} (IP Camera)", style: utils.smallLabelStyle(theme.blackColor),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h,),
                              Container(
                                width: Get.width,
                                height: 1,
                                color: theme.grayColor,
                              ),
                            ],
                          )
                      ],
                    );
                  }),
                  SizedBox(height: 12.w,),
                ],
              ),
            )
          ],
        ),
      ),
      barrierDismissible: false
    );
  }

  void getImage() async {
    var result = await _picker.pickImage(source: ImageSource.camera,  imageQuality: 30);

    if(result != null){
      setState(() {
        _image = File(result.path);
      });
      var imageData = await utils.convertToBase64(_image!);
      widget.entryModel.vehicleData.add(VehicleDataModel(imageType: imageTypeVisitor, imageData: imageData));
    }
  }
}
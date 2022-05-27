import 'dart:io';

import 'package:cnic_scanner/cnic_scanner.dart';
import 'package:cnic_scanner/model/cnic_model.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/Models/ExitVehicleModel.dart';
import 'package:connect_vms/Models/ExitVehiclePostModel.dart';
import 'package:connect_vms/Models/VehicleDataModel.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:connect_vms/Views/print_screens/PrintScreen.dart';
import 'package:connect_vms/Widgets/home/HomeAppBar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../AppConstants/Constants.dart';
import '../../GetxController/VehicleController.dart';
import '../ip_camera_screens/IPCameraScreen.dart';

class ExitDetailScreen extends StatefulWidget{
  ExitVehicleModel exitVehicleModel;
  ExitDetailScreen(this.exitVehicleModel);
  @override
  _ExitDetailScreen createState() => _ExitDetailScreen();
}

class _ExitDetailScreen extends State<ExitDetailScreen>{
  var utils = AppUtils();
  ThemeController theme = Get.find();

  var cnicController = TextEditingController();
  var nameController = TextEditingController();

  ImagePicker _picker = ImagePicker();
  File? _imageVehicle;
  File? _imageGatePass;
  List<VehicleDataModel> vehicleData = [];

  @override
  void initState() {
    super.initState();
    cnicController.text = "${widget.exitVehicleModel.driverCNIC}";
    nameController.text = "${widget.exitVehicleModel.driverName}";
  }


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
                    HomeAppBar(true, isExist: true,),
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
                                          Text("${widget.exitVehicleModel.vehicleType??0}", style: utils.boldLabelStyle(theme.greenColor),textAlign: TextAlign.center,),
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
                                          Text("${DateFormat("dd MMM, yyyy hh:mm:ss aa").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse("${widget.exitVehicleModel.inTime}"))}", style: utils.labelStyle(theme.secondaryColor),textAlign: TextAlign.center,),
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
                                          Text("RFID", style: utils.boldLabelStyle(theme.blackColor),),
                                          SizedBox(height: 8.h,),
                                          Text("${"${widget.exitVehicleModel.rFIDNo}"}", style: utils.labelStyle(theme.secondaryColor),textAlign: TextAlign.center,),
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
                                          Text("Plate No.", style: utils.boldLabelStyle(theme.blackColor),),
                                          SizedBox(height: 8.h,),
                                          Text("${"${widget.exitVehicleModel.vehicleNo}"}", style: utils.labelStyle(theme.secondaryColor), textAlign: TextAlign.center,),
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
                                SizedBox(height: 20.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Vehicle", style: utils.labelStyle(theme.blackColor),),
                                        SizedBox(height: 6.h,),
                                        DottedBorder(
                                            color: theme.mainColor.withOpacity(0.4),
                                            radius: Radius.circular(12.w),
                                            borderType: BorderType.RRect,
                                            strokeWidth: 2,
                                            strokeCap: StrokeCap.butt,
                                            child: AspectRatio(
                                              aspectRatio: 16/9,
                                              child: Container(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12.w),
                                                ),
                                                child: _imageVehicle == null ? Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.add_photo_alternate_outlined, color: theme.blackColor.withOpacity(0.2), size: 52.w,),
                                                    SizedBox(height: 8.h,),
                                                    InkWell(
                                                      onTap: (){
                                                        showBottomCameraSheet(2);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            color: theme.mainColor
                                                        ),
                                                        child: Text("Vehicle", style: utils.smallLabelStyle(theme.whiteColor),),
                                                      ),
                                                    )
                                                  ],
                                                ) :
                                                Stack(
                                                  children: [
                                                    Container(
                                                        width: Get.width,
                                                        height: Get.height,
                                                        child: Image.file(_imageVehicle!, fit: BoxFit.cover,)
                                                    ),
                                                    Positioned(
                                                      bottom: 2.w,
                                                      left: 2.w,
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          showBottomCameraSheet(2);
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
                                                              Text("Reload", style: utils.smallLabelStyle(theme.blackColor),)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 2.w,
                                                      right: 2.w,
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            _imageVehicle = null;
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        )
                                      ],
                                    )),
                                    SizedBox(width: 12.w,),
                                    Expanded(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Gate Pass", style: utils.labelStyle(theme.blackColor),),
                                        SizedBox(height: 6.h,),
                                        DottedBorder(
                                            color: theme.mainColor.withOpacity(0.4),
                                            radius: Radius.circular(12.w),
                                            borderType: BorderType.RRect,
                                            strokeWidth: 2,
                                            strokeCap: StrokeCap.butt,
                                            child: AspectRatio(
                                              aspectRatio: 16/9,
                                              child: Container(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12.w),
                                                ),
                                                child: _imageGatePass == null ? Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.add_photo_alternate_outlined, color: theme.blackColor.withOpacity(0.2), size: 52.w,),
                                                    SizedBox(height: 8.h,),
                                                    InkWell(
                                                      onTap: (){
                                                        showBottomCameraSheet(3);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8.w),
                                                            color: theme.mainColor
                                                        ),
                                                        child: Text("Gate Pass", style: utils.smallLabelStyle(theme.whiteColor),),
                                                      ),
                                                    )
                                                  ],
                                                ) :
                                                Stack(
                                                  children: [
                                                    Container(
                                                        width: Get.width,
                                                        height: Get.height,
                                                        child: Image.file(_imageGatePass!, fit: BoxFit.cover,)
                                                    ),
                                                    Positioned(
                                                      bottom: 2.w,
                                                      left: 2.w,
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          showBottomCameraSheet(3);
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
                                                              Text("Reload", style: utils.smallLabelStyle(theme.blackColor),)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 2.w,
                                                      right: 2.w,
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            _imageGatePass = null;
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        )
                                      ],
                                    )),
                                  ],
                                ),
                                SizedBox(height: 20.h,),
                                Container(
                                  width: Get.width,
                                  height: 1.h,
                                  color: theme.grayColor,
                                ),
                                SizedBox(height: 20.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("CNIC", style: utils.smallLabelStyle(theme.blackColor.withOpacity(0.8)),),
                                        SizedBox(height: 8.h,),
                                        utils.textField(theme.whiteColor, CupertinoIcons.creditcard, theme.mainColor, CupertinoIcons.square_stack_3d_down_right_fill, theme.mainColor, theme.blackColor, "CNIC", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, false, cnicController, onClickSuffix: () async {
                                        }, onClick: (){})
                                      ],
                                    )),
                                    SizedBox(width: 12.w,),
                                    Expanded(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Name", style: utils.smallLabelStyle(theme.blackColor.withOpacity(0.8)),),
                                        SizedBox(height: 8.h,),
                                        utils.textField(theme.whiteColor, CupertinoIcons.person, theme.mainColor, null, null, theme.blackColor, "Name", theme.blackColor.withOpacity(0.5), theme.mainColor, 1.0, Get.width, false, nameController, onClick: (){})
                                      ],
                                    )),
                                  ],
                                ),
                                SizedBox(height: 50.h,),
                                utils.button(theme.mainColor, "Finish", theme.whiteColor, theme.mainColor, 1.0, (){
                                  ExitVehiclePostModel exitVehicleModel = ExitVehiclePostModel(exitTime: "${DateFormat("yyyy-MM-dd hh:mm:ss aa").format(DateTime.now())}", exitDeviceType: "exit", recNo: int.parse(widget.exitVehicleModel.recNo??"0"), charges: widget.exitVehicleModel.totalFare, vehicleData: vehicleData);
                                  exitVehicleModel.driverName = widget.exitVehicleModel.driverName;
                                  exitVehicleModel.driverCNIC = widget.exitVehicleModel.driverCNIC??"";
                                  exitVehicleModel.vehicleNo = widget.exitVehicleModel.vehicleNo??"";
                                  exitVehicleModel.entryTime = widget.exitVehicleModel.inTime;
                                  Get.to(()=> PrintScreen(null, exitVehicleModel,1));
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

  void showBottomCameraSheet(type) {
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
                        getImage(type);
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
                                    if(type == 2){
                                      if(ipImageGlobal != null){
                                        _imageVehicle = await utils.convertImage(ipImageGlobal!);
                                      }
                                    }else if(type == 3){
                                      if(ipImageGlobal != null){
                                        _imageGatePass = await utils.convertImage(ipImageGlobal!);
                                      }
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

  void getImage(type) async {
    var result = await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);

    if(result != null){
      setState(() {
        if(type == 2){
          _imageVehicle = File(result.path);
        }else{
          _imageGatePass = File(result.path);
        }
      });

      if(type == 2){
        var imageData = await utils.convertToBase64(_imageVehicle!);
        vehicleData.add(
            VehicleDataModel(imageType: imageTypeVehicle, imageData: imageData));
      }else{
        var imageData = await utils.convertToBase64(_imageGatePass!);
        vehicleData.add(
            VehicleDataModel(imageType: imageTypeGate, imageData: imageData));
      }
    }
  }
}
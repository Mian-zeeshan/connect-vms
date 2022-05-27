import 'dart:typed_data';

import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../AppConstants/Constants.dart';

class IpCameraScreen extends StatefulWidget{
  String ip;
  IpCameraScreen(this.ip);
  @override
  _IpCameraScreen createState() => _IpCameraScreen();

}

class _IpCameraScreen extends State<IpCameraScreen>{
  var utils = AppUtils();
  ThemeController theme = Get.find();
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? _imageFile;

  @override
  void initState() {
    ipImageGlobal = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: theme.whiteColor,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              child: Screenshot(
                controller: screenshotController,
                child: Mjpeg(
                  isLive: true,
                  stream: 'http://46.151.101.134:8082/?action=stream',
                ),
              ),
            ),
            if(_imageFile != null) Container(
              width: Get.width,
              height: Get.height,
              color: theme.whiteColor,
              child: Center(child: Image.memory(_imageFile!)),
            ),
            Container(
              width: Get.width,
              height: Get.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: Get.width,
                      padding: EdgeInsets.all(20),
                      color: theme.blackColor.withOpacity(0.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_imageFile != null)
                            InkWell(
                              hoverColor: theme.mainColor,
                              onTap: () {
                                ipImageGlobal = _imageFile;
                                Get.back();
                              },
                              child: Container(
                                width: 50.h,
                                height: 50.h,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: theme.greenColor)),
                                child: Container(
                                  width: 50.h,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.greenColor),
                                  child: _imageFile == null
                                      ? null
                                      : Center(
                                          child: Icon(
                                            CupertinoIcons.check_mark,
                                            color: theme.whiteColor,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          if(_imageFile != null) SizedBox(width: 20.w,),
                        InkWell(
                          hoverColor: theme.mainColor,
                          onTap: (){
                            if(_imageFile == null) {
                              getLastImage();
                            }else{
                              _imageFile = null;
                              setState(() {
                              });
                            }
                          },
                          child: Container(
                            width: 50.h,
                            height: 50.h,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: _imageFile == null ? theme.whiteColor : theme.redColor)
                            ),
                            child: Container(
                              width: 50.h,
                              height: 50.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                color: _imageFile == null ? theme.whiteColor : theme.redColor
                              ),
                              child: _imageFile == null ? null : Center(
                                child: Icon(CupertinoIcons.xmark, color: _imageFile == null ? theme.blackColor : theme.whiteColor,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
            Positioned(
              top: 12.h,
                left: 12.h,
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.blackColor.withOpacity(0.4),
              ),
              child: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: Icon(CupertinoIcons.arrow_left, color: theme.whiteColor,),
              ),
            ))
          ],
        ),
      ),
    );
  }


  getLastImage() async {
    screenshotController.capture().then((Uint8List? image) {
      if(image != null) {
        setState(() {
          _imageFile = image;
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
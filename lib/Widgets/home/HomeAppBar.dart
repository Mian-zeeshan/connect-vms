import 'package:connect_vms/GetxController/AppbarController.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/GetxController/UserController.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatefulWidget{
  bool allowBack;
  bool? isExist = false;
  HomeAppBar(this.allowBack,{this.isExist = false});
  @override
  _HomeAppBar createState() => _HomeAppBar();
}

class _HomeAppBar extends State<HomeAppBar>{
  ThemeController theme = Get.find();
  var utils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(id: "0", builder: (userController){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: theme.mainColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.w))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                if(widget.allowBack)
                  Get.back();
              },
              child: Container(
                width: 50.w,
                height: 50.w,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.whiteColor
                ),
                child: Image.asset("assets/images/parkA.jpg", fit: BoxFit.cover,),
              ),
            ),
            SizedBox(width: 12.w,),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${userController.userModel != null ? userController.userModel!.name??"No Name" : ""}", style: utils.boldLabelStyle(theme.whiteColor),),
                SizedBox(height: 4.h,),
                if(widget.isExist != null) Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.circle_fill, color: widget.isExist!? theme.redColor : theme.greenColor, size: 16,),
                    SizedBox(width: 2.w,),
                    Text(widget.isExist! ? "Exit" : "Entry", style: utils.labelStyle(theme.whiteColor),),
                  ],
                )
              ],
            )),
            Text("${userController.userModel != null ? userController.userModel!.gateName??"Gate" : "Gate"}", style: utils.headingStyle(theme.whiteColor.withOpacity(1)),),
            Expanded(child: GetBuilder<AppbarController>(id: "0",builder: (appBarController){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${appBarController.time}", style: utils.boldLabelStyle(theme.whiteColor),),
                  SizedBox(height: 4.h,),
                  Text("${appBarController.date}", style: utils.labelStyle(theme.whiteColor.withOpacity(0.6)),),
                ],
              );
            }))
          ],
        ),
      );
    },);
  }

}
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../AppConstants/Constants.dart';
import '../GetxController/ThemeController.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils{
  xLHeadingStyle(color){
    return TextStyle(
        color: color,
        fontSize: xHeadingFontSize.sp,
        fontWeight: xBold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  xxLHeadingStyle(color){
    return TextStyle(
        color: color,
        fontSize: xxHeadingFontSize.sp,
        fontWeight: xBold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  smallLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  smallLabelStyleUnderline(color){
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.underline,
        fontFamily: 'Roboto'
    );
  }

  xSmallLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: xSmallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  xBoldSmallLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: xSmallFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  smallLabelStyleSlash(color){
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.lineThrough,
        fontFamily: 'Roboto'
    );
  }
  xSmallLabelStyleSlash(color){
    return TextStyle(
        color: color,
        fontSize: xSmallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.lineThrough,
        fontFamily: 'Roboto'
    );
  }

  boldSmallLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  labelStyle(color){
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  labelStyleUnderline(color){
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.underline,
        fontFamily: 'Roboto'
    );
  }

  headingStyle(color){
    return TextStyle(
        color: color,
        fontSize: headingFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  headingStyle2(color){
    return TextStyle(
        color: color,
        fontSize: headingFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  boldLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  boldLabelStyleSlash(color){
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.lineThrough,
        fontFamily: 'Roboto'
    );
  }

  buttonStyle(color){
    return TextStyle(
        color: color,
        fontSize: buttonFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  button( bgColor,  text,  textColor,  borderColor,  borderWidth,  onPress ,{secondaryColor, }) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor , width: borderWidth),
          color: secondaryColor == null ? bgColor : null,
          gradient: secondaryColor == null ? null : LinearGradient(colors: [bgColor,secondaryColor])
        ),
        child: Center(
          child: Text(text , style: buttonStyle(textColor),),
        ),
      ),
    );
  }

  textField(bgColor , preIcon , preIconColor, suffixIcon , suffixIconColor, textColor , hint, hintColor, borderColor , borderWidth , width , isSecure , controller , {multiline ,isNumber, isPhone , onTextChange , imageIcon , onClick , onClickSuffix}){
    return InkWell(
      onTap: onClick,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: multiline != null ? BorderRadius.circular(12) : BorderRadius.circular(8),
            border: Border.all(color: borderColor , width: borderWidth)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: multiline != null ? CrossAxisAlignment.center: CrossAxisAlignment.center,
          children: [
            if(preIcon != null) imageIcon == null ? Icon(preIcon, color: preIconColor,size: 20,) : Image.asset(imageIcon , width: 20 , height: 20, color: preIconColor,),
            if(preIcon != null) SizedBox(width: 10,),
            Expanded(child: TextFormField(
              onChanged: onTextChange,
              enabled: onClick == null,
              obscureText: isSecure,
              controller: controller,
              keyboardType: isPhone != null ? TextInputType.phone : isNumber != null ? TextInputType.number : TextInputType.text,
              maxLines: multiline != null ? 3 : 1,
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: labelStyle(hintColor),
                  border: InputBorder.none,
              ),
              style: labelStyle(textColor),
            )),
            if(suffixIcon != null) SizedBox(width: 10,),
            if(suffixIcon != null) InkWell(onTap: onClickSuffix,child: Icon(suffixIcon, color: suffixIconColor,size: 20,)),
          ],
        ),
      ),
    );
  }

  dateFromStamp(int createdAt) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(createdAt));
  }

  Widget tabStyle(index, String name, color) {
    ThemeController theme = Get.find();
    return Visibility(
      child: Container(
        decoration: BoxDecoration(
            color: index ? color
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: index
                    ? color
                    : Colors.transparent)),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name,
                style: labelStyle(index
                    ? theme.whiteColor
                    : theme.blackColor.withOpacity(0.5))
            )
          ],
        ),
      ),
    );
  }

  dottedCustomLine(color){
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: color,
      dashRadius: 0.0,
      dashGapLength: 6.0,
      dashGapColor: Colors.transparent,
      dashGapRadius: 0.0,
    );
  }

  fullLine(color){
    return Container(
      width: Get.width,
      height: 1,
      color: color,
    );
  }

  showAlert(icon, iconColor, title, description, positiveButton, negativeButton, onClickPositive, onClickNegative){
    ThemeController theme = Get.find();
    Get.dialog(Container(
      width: Get.width,
      height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.whiteColor
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, color: iconColor, size: 56.w,),
                  ],
                ),
                SizedBox(height: 12.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(title, style: boldLabelStyle(theme.blackColor), textAlign: TextAlign.center,)),
                  ],
                ),
                SizedBox(height: 6.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(description, style: xSmallLabelStyle(theme.blackColor), textAlign: TextAlign.center,)),
                  ],
                ),
                SizedBox(height: 12.h,),
                fullLine(theme.blackColor.withOpacity(0.5)),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: InkWell(
                        onTap: onClickNegative,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: Text(negativeButton, style: boldSmallLabelStyle(theme.redColor),),
                          ),
                        ),
                      )),
                      Container(
                        width: 1,
                        color: theme.blackColor.withOpacity(0.5),
                      ),
                      Expanded(child: InkWell(
                        onTap: onClickPositive,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: Text(positiveButton, style: boldSmallLabelStyle(theme.greenColor),),
                          ),
                        ),
                      )),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ), barrierDismissible: true);
  }


  Future<String> convertToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<File> convertImage(Uint8List _imageFile) async {
    Uint8List imageInUnit8List = _imageFile;
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(imageInUnit8List);
    return file;
  }
}
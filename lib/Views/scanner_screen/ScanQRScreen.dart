import 'dart:developer';
import 'dart:io';

import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../AppConstants/Constants.dart';
import '../../GetxController/ThemeController.dart';

class ScanQRScreen extends StatefulWidget {
  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  TextEditingController searchController = new TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool flashOn = false;
  var utils = AppUtils();
  ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 10),
                    borderRadius: BorderRadius.circular(30)),
                child: buildQrScan(),
              ),
              Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    height: 80.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "Scan".tr,
                                      style: utils.headingStyle(themeController.blackColor)
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  )),
              Positioned(
                top: 25,
                left: 15,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Positioned(
                top: 25,
                right: 15,
                child: InkWell(
                  onTap: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      flashOn = !flashOn;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: flashOn
                        ? Icon(Icons.flash_on_rounded)
                        : Icon(Icons.flash_off_rounded),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            "assets/images/qrcode.png",
                            width: 20.w,
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Scan'.tr,
                                style: utils.boldLabelStyle(themeController.blackColor)
                            )
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget buildQrScan() {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: themeController.mainColor,
          borderRadius: 30,
          borderLength: 60,
          borderWidth: 30,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      setState(() {
        result = scanData;
      });
      print(result!.code);
      qrCode = result!.code!;
      if(Get.routing.current == "/ScanQRScreen")
        Get.back();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
}
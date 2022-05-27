import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:connect_vms/AppConstants/Constants.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/GetxController/UserController.dart';
import 'package:connect_vms/GetxController/VehicleController.dart';
import 'package:connect_vms/Models/ExitVehiclePostModel.dart';
import 'package:connect_vms/Models/VehicleEntryModel.dart';
import 'package:connect_vms/Utils/AppUtils.dart';
import 'package:connect_vms/Views/home_screens/HomeScreen.dart';
import 'package:connect_vms/Widgets/home/HomeAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

class PrintScreen extends StatefulWidget{
  VehicleEntryModel? vehicleEntryModel;
  ExitVehiclePostModel? exitVehiclePostModel;
  int type;
  PrintScreen(this.vehicleEntryModel, this.exitVehiclePostModel, this.type);
  @override
  _PrintScreen createState() => _PrintScreen();
}

class _PrintScreen extends State<PrintScreen>{
  var utils = AppUtils();
  ThemeController theme = Get.find();
  UserController userController = Get.find();
  VehicleController _vehicleController = Get.find();

  //print

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _pressed = false;
  String? pathImage;

  @override void initState() {
    super.initState();
    initPlatformState();
    initSavetoPath();
  }

  initSavetoPath()async{
    //read and write
    //image max 300px X 300px
    final filename = 'parking.png';
    var bytes = await rootBundle.load("assets/images/parking.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    //writeToFile(bytes,'$dir/$filename');
    setState(() {
      pathImage='$dir/$filename';
    });
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {

    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _device = savedDevice;
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _device = savedDevice;
            if(_device != null) {
              _connected = true;
              _pressed = false;
            }
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          if(savedDevice != null){
            _device = savedDevice;
            _connect();
          }
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          if(savedDevice != null){
            _device = savedDevice;
            _connect();
          }
          print("State Current ${state}");
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(id:"0",builder: (themeController){
      theme = themeController;
      return Scaffold(
        backgroundColor: theme.whiteColor,
        floatingActionButton: InkWell(
          onTap: (){
              utils.showAlert(CupertinoIcons.arrowshape_turn_up_left_2, theme.redColor, "Exit", "Do you really want to exit from this page?", "Okay", "Cancel", (){
                Get.offAll(()=> HomeScreen(userController.userModel!.gateType??"hybrid"));
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
              child: Icon(CupertinoIcons.house_fill, color: theme.whiteColor, size: 24,),
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
                    HomeAppBar(true, isExist: widget.type == 0 ? false : true,),
                    Expanded(child: SingleChildScrollView(
                      child: Container(
                        width: Get.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width,
                              child: AspectRatio(
                                aspectRatio: 20/9,
                                  child: Lottie.asset("assets/images/print_ani.json")
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: Get.width*0.15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.printer, color: theme.blackColor, size: 20,),
                                      SizedBox(width: 8.w,),
                                      Text("Printer Status:", style: utils.labelStyle(theme.blackColor), textAlign: TextAlign.start,),
                                      SizedBox(width: 8.w,),
                                      Text(" ${_connected ? "Connected with ${_device?.name}" : "Disconnected"}", style: utils.labelStyle(_connected ? theme.greenColor : theme.redColor), textAlign: TextAlign.start,),
                                    ],
                                  ),
                                  SizedBox(height: 20.h,),
                                  utils.dottedCustomLine(theme.blackColor.withOpacity(0.5)),
                                  SizedBox(height: 8.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Connect VMS", style: utils.xLHeadingStyle(theme.blackColor.withOpacity(0.5)),)
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  utils.dottedCustomLine(theme.blackColor.withOpacity(0.5)),
                                  SizedBox(height: 16.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("Gate", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text("${userController.userModel!.gateName??"N/A"}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("Name", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text(widget.type == 0 ? "${widget.vehicleEntryModel!.driverName}":"${widget.exitVehiclePostModel!.driverName}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("CNIC", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text(widget.type == 0 ? "${widget.vehicleEntryModel!.driverCNIC}":"${widget.exitVehiclePostModel!.driverCNIC}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("Vehicle No.", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text(widget.type == 0 ? "${widget.vehicleEntryModel!.vehicleNumber}":"${widget.exitVehiclePostModel!.vehicleNo}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("In Date", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text("${DateFormat("dd MMM, yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.type == 0 ? "${widget.vehicleEntryModel!.enterTime}":"${widget.exitVehiclePostModel!.entryTime}"))}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  if(widget.type == 1) SizedBox(height: 8.h,),
                                  if(widget.type == 1) Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("Out Date", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text("${DateFormat("dd MMM, yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss aa").parse(widget.type == 0 ? "${widget.vehicleEntryModel!.enterTime}":"${widget.exitVehiclePostModel!.exitTime}"))}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("In Time", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text("${DateFormat("hh:mm:ss aa").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.type == 0 ? "${widget.vehicleEntryModel!.enterTime}":"${widget.exitVehiclePostModel!.entryTime}"))}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  if(widget.type == 1) SizedBox(height: 8.h,),
                                  if(widget.type == 1) Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("Out Time", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text("${DateFormat("hh:mm:ss aa").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.type == 0 ? "${widget.vehicleEntryModel!.enterTime}":"${widget.exitVehiclePostModel!.exitTime}"))}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  if(widget.type == 1) Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text("Charges", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                      Expanded(
                                          child: Text("${widget.exitVehiclePostModel!.charges}", style: utils.labelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h,),
                                  utils.dottedCustomLine(theme.blackColor.withOpacity(0.5)),
                                  SizedBox(height: 8.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("VMS Generated Pass", style: utils.xSmallLabelStyle(theme.blackColor.withOpacity(0.5)), textAlign: TextAlign.start,),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  utils.dottedCustomLine(theme.blackColor.withOpacity(0.5)),
                                  SizedBox(height: 24.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(child: InkWell(
                                        onTap: (){
                                            showPrinters();
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.printer, color: theme.mainColor, size: 20,),
                                            SizedBox(width: 8.w,),
                                            Text("Connect Printer", style: utils.labelStyle(theme.mainColor), textAlign: TextAlign.start,),
                                          ],
                                        ),
                                      )),
                                      if(_connected) Expanded(child: InkWell(
                                        onTap: (){
                                          if(_connected && !_pressed){
                                            printR();
                                            if(widget.type == 0) {
                                              _vehicleController.enterVehicle(
                                                  widget.vehicleEntryModel!);
                                            }else{
                                              _vehicleController.exitVehicle(
                                                  widget.exitVehiclePostModel!);
                                            }
                                          }else{
                                            Get.snackbar("Error", "Connect the printer first");
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.printer, color: theme.mainColor, size: 20,),
                                            SizedBox(width: 8.w,),
                                            if(_connected) Text("Print", style: utils.labelStyle(theme.mainColor), textAlign: TextAlign.start,),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  showPrinters() {
    Get.dialog(
      Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.whiteColor
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Select Printer", style: utils.headingStyle(theme.blackColor),),
                  SizedBox(height: 12.h,),
                  SizedBox(height: 12.h,),
                  for(var i = 0 ; i < _devices.length; i++)
                    InkWell(
                      onTap: (){
                        Get.back();
                        _device = _devices[i];
                        savedDevice = _device;
                        _connect();
                      },
                      child: Container(
                        width: Get.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${i+1})", style: utils.smallLabelStyle(theme.blackColor),),
                                SizedBox(width: 12.h,),
                                Icon(CupertinoIcons.printer, color: theme.blackColor, size: 16,),
                                SizedBox(width: 12.h,),
                                Text("${_devices[i].name}", style: utils.smallLabelStyle(theme.blackColor),),
                              ],
                            ),
                            SizedBox(height: 6.h,),
                            if(i != _devices.length-1) utils.fullLine(theme.blackColor.withOpacity(0.6))
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 20.h,),
                  utils.button(theme.mainColor, "Close", theme.whiteColor, theme.mainColor, 1.0, (){
                    Get.back();
                  })
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  void _connect() {
    if (_device == null) {
      Get.snackbar("Error", 'No device selected.');
    } else {
      EasyLoading.show(status: "Loading");
      bluetooth.isConnected.then((isConnected) {
        if (!(isConnected??false)) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _pressed = false);
            EasyLoading.dismiss();
          }).then((value){
            EasyLoading.dismiss();
          });
          setState(() => _pressed = true);
        }else{
          EasyLoading.dismiss();
        }
      });
    }
  }

  void printR() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) async {
      if (isConnected??false) {
        _pressed = true;
        setState(() {
        });
        await bluetooth.printNewLine();
        await bluetooth.printCustom("------------------------------------------",0,1);
        await bluetooth.printCustom("CONNECT VMS",3,1);
        await bluetooth.printCustom("------------------------------------------",0,1);
        //if(pathImage != null)
        //  bluetooth.printImage(pathImage!);   //path of your image/logo
        await bluetooth.printCustom("${userController.userModel!.gateName??"N/A"}",2,1);
        await bluetooth.printLeftRight("Name", widget.type == 0 ? "${widget.vehicleEntryModel!.driverName}" : "${widget.exitVehiclePostModel!.driverName}",0, format: "%-15s %15s %n");
        await bluetooth.printLeftRight("CNIC", widget.type == 0 ? "${widget.vehicleEntryModel!.driverCNIC}":"${widget.exitVehiclePostModel!.driverCNIC}",0, format: "%-15s %15s %n");
        await bluetooth.printLeftRight("Vehicle No.", widget.type == 0 ? "${widget.vehicleEntryModel!.vehicleNumber}":"${widget.exitVehiclePostModel!.vehicleNo}",0, format: "%-15s %15s %n");
        await bluetooth.printLeftRight("In Date", "${DateFormat("dd MMM, yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.type == 0 ? "${widget.vehicleEntryModel!.enterTime}":"${widget.exitVehiclePostModel!.entryTime}"))}",0, format: "%-15s %15s %n");
        if(widget.type == 1) await bluetooth.printLeftRight("Out Date", "${DateFormat("dd MMM, yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.type == 0 ? "${widget.vehicleEntryModel!.enterTime}":"${widget.exitVehiclePostModel!.exitTime}"))}",0, format: "%-15s %15s %n");
        await bluetooth.printLeftRight("In Time", "${DateFormat("hh:mm:ss aa").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.type == 0 ? "${widget.vehicleEntryModel!.enterTime}":"${widget.exitVehiclePostModel!.entryTime}"))}",0, format: "%-15s %15s %n");
        if(widget.type == 1) await bluetooth.printLeftRight("Out Time", "${DateFormat("hh:mm:ss aa").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.type == 0 ? "${widget.vehicleEntryModel!.enterTime}":"${widget.exitVehiclePostModel!.exitTime}"))}",0, format: "%-15s %15s %n");
        await bluetooth.printCustom("------------------------------------------",0,1);
        await bluetooth.printLeftRight("", "VMS Generated Pass",0);
        await bluetooth.printCustom("------------------------------------------",0,1);
        // bluetooth.print3Column("Col1", "Col2", "Col3",1,format: "%-10s %10s %10s %n");
        // bluetooth.print4Column("Col1","Col2","Col3","Col4",1,format: "%-8s %7s %7s %7s %n" );
        // String testString = " čĆžŽšŠ-H-ščđ";
        // bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
        // bluetooth.printLeftRight("Številka:", "18000001", 1, charset: "windows-1250");
        // bluetooth.printCustom("Body left",1,0);
        // bluetooth.printCustom("Body right",0,2);
        // bluetooth.printNewLine();
        // bluetooth.printCustom("Thank You",2,1);
        // bluetooth.printNewLine();
        await bluetooth.printQRcode("Plate: ${widget.type == 0 ? "${widget.vehicleEntryModel!.vehicleNumber}":"${widget.exitVehiclePostModel!.vehicleNo}"}, CNIC: ${widget.type == 0 ? "${widget.vehicleEntryModel!.vehicleNumber}":"${widget.exitVehiclePostModel!.driverCNIC}"}, Name: ${widget.type == 0 ? "${widget.vehicleEntryModel!.vehicleNumber}":"${widget.exitVehiclePostModel!.driverName}"}", 160, 160, 1);
        await bluetooth.printNewLine();
        await bluetooth.printNewLine();
        await bluetooth.paperCut();
        _pressed = false;
        setState(() {
        });
      }
    });
  }
}
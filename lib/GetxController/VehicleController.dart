import 'dart:convert';

import 'package:connect_vms/GetxController/PendingRequestsController.dart';
import 'package:connect_vms/Models/DevicesModel.dart';
import 'package:connect_vms/Models/ExitVehicleModel.dart';
import 'package:connect_vms/Models/ExitVehiclePostModel.dart';
import 'package:connect_vms/Models/UserModel.dart';
import 'package:connect_vms/Models/VehicleEntryModel.dart';
import 'package:connect_vms/Models/VehicleTypeModel.dart';
import 'package:connect_vms/Models/VisitPlaceModel.dart';
import 'package:connect_vms/services/VehicleApis.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../AppConstants/Constants.dart';
import '../Models/PendingRequestsModel.dart';
import '../Views/auth_screens/LoginScreen.dart';

class VehicleController extends GetxController{
  late UserModel userModel;
  var box = GetStorage();
  VehicleTypeModel vehicleTypeModel = VehicleTypeModel(status: 400, error: true, messages: "Somthing wemt wrong please check your internet connection", data: []);
  DevicesModel devicesModel = DevicesModel(status: 400, error: true, data: []);
  VisitPlaceModel visitPlaceModel = VisitPlaceModel(status: 400, error: true, data: []);
  var isLoadingVehicles = true;
  PendingRequestsController pendingRequestsController = Get.find();

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  void GetVehicles({mounted = false}) async {
    isLoadingVehicles = true;
    if(mounted){
      update(["0"]);
      notifyChildrens();
    }
    VehicleApis apis = VehicleApis();

    var response = await apis.getVehicleType(userModel.token);
    if(response.statusCode == 201){
      vehicleTypeModel = VehicleTypeModel.fromJson(jsonDecode(jsonEncode(response.body)));
      await box.write("api/vehicletypesbygateid/${userModel.userId}", response.body);
    }else{
      var value = await box.read("api/vehicletypesbygateid/${userModel.userId}");
      if(value != null){
        vehicleTypeModel = VehicleTypeModel.fromJson(jsonDecode(jsonEncode(value)));
      }
    }
    isLoadingVehicles = true;
    update(["0"]);
    notifyChildrens();
  }

  void GetCameras() async {
    VehicleApis apis = VehicleApis();

    var response = await apis.getCameras(userModel.token);
    if(response.statusCode == 201){
      devicesModel = DevicesModel.fromJson(jsonDecode(jsonEncode(response.body)));
      print(devicesModel.toJson());
      await box.write("api/devicesbygateid/${userModel.userId}", response.body);
      update(["0"]);
      notifyChildrens();
    }else{
      var value = await box.read("api/devicesbygateid/${userModel.userId}");
      if(value != null){
        devicesModel = DevicesModel.fromJson(jsonDecode(jsonEncode(value)));
        print(devicesModel.toJson());
      }
    }
  }

  void GetVisitPlaces() async {
    VehicleApis apis = VehicleApis();

    var response = await apis.GetVisitTypes(userModel.token);
    if(response.statusCode == 201){
      visitPlaceModel = VisitPlaceModel.fromJson(jsonDecode(jsonEncode(response.body)));
      await box.write("api/getvisitingplaces/${userModel.userId}", response.body);
    }else{
      var value = await box.read("api/getvisitingplaces/${userModel.userId}");
      if(value != null){
        visitPlaceModel = VisitPlaceModel.fromJson(jsonDecode(jsonEncode(value)));
      }
    }
    update(["0"]);
    notifyChildrens();
  }

  bool searchVehicle(String name){
    if(vehicleTypeModel.data.length > 0){
      var isExist = false;

      for(var i = 0; i < vehicleTypeModel.data.length; i++){
        if((vehicleTypeModel.data[i].vehicletypeName??"").toLowerCase().contains(name.toLowerCase())){
          isExist = true;
          break;
        }
      }

      return isExist;
    }else{
      return true;
    }
  }

  void getUser() async {
    var value = await box.read(currentUser);
    print(value);
    if(value != null){
      userModel = UserModel.fromJson(jsonDecode(jsonEncode(value)));
      GetVehicles();
      GetCameras();
      GetVisitPlaces();
    }else{
      Get.offAll(()=> LoginScreen());
    }
  }

  getVehicleFromType(String vehicleTypeID) {
    String type = "N/A";
    for(var a in vehicleTypeModel.data){
      if((a.vehicletypeId??"0") == vehicleTypeID){
        type = a.vehicletypeName??"N/A";
      }
    }
    return type;
  }

  void enterVehicle(VehicleEntryModel vehicleEntryModel) async {
    VehicleApis apis = VehicleApis();

    Response response = await apis.enterVehicle(userModel.token, vehicleEntryModel.toJson());
    print("Data ENTRY LOGS");
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 201){
      DevicesModel devicesModel = DevicesModel.fromJson(jsonDecode(jsonEncode(response.body)));
      if(devicesModel.status == 200){

      }else{
        vehicleEntryModel.token = userModel.token;
        pendingRequestsController.addRequest(vehicleEntryModel.toJsonToken());
      }
    }else{
      vehicleEntryModel.token = userModel.token;
      pendingRequestsController.addRequest(vehicleEntryModel.toJsonToken());
    }
  }

  void exitVehicle(ExitVehiclePostModel exitVehiclePostModel) async {
    VehicleApis apis = VehicleApis();

    Response response = await apis.exitVehicle(userModel.token, exitVehiclePostModel.toJson());
    print("Data ENTRY LOGS");
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 201){
      DevicesModel devicesModel = DevicesModel.fromJson(jsonDecode(jsonEncode(response.body)));
      if(devicesModel.status == 200){

      }else{
        exitVehiclePostModel.token = userModel.token;
        pendingRequestsController.addRequestExit(exitVehiclePostModel.toJsonToken());
      }
    }else{
      exitVehiclePostModel.token = userModel.token;
      pendingRequestsController.addRequest(exitVehiclePostModel.toJsonToken());
    }
  }

  Future<ExitVehicleModel?> getVehicleById(String? cnic, String? rfid, String? plateNo) async {
    VehicleApis apis = VehicleApis();
    var data = {
      "VehicleNumber" : plateNo??"",
      "CNIC" : cnic??"",
      "RFID_CardNo" : rfid??""
    };
    Response response = await apis.getVehicleById(userModel.token,data);
    print("Data EXIT LOGS");
    print(response.body);
    print(response.statusCode);
    ExitVehicleModel? exitVehicleModel;
    if(response.statusCode == 201){
      exitVehicleModel = ExitVehicleModel.fromJson(jsonDecode(jsonEncode(response.body)));
    }
    return exitVehicleModel;
  }
}
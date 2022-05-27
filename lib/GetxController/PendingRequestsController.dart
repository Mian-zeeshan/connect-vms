import 'dart:async';
import 'dart:convert';

import 'package:connect_vms/Models/PendingRequestsModel.dart';
import 'package:connect_vms/Models/VehicleEntryModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../AppConstants/Constants.dart';
import '../Models/DevicesModel.dart';
import '../Models/ExitVehiclePostModel.dart';
import '../services/VehicleApis.dart';

class PendingRequestsController extends GetxController{
  PendingRequestsModel pendingRequestsModel = PendingRequestsModel(requests: []);
  PendingRequestsModel pendingRequestsModelExit = PendingRequestsModel(requests: []);
  var box = GetStorage();
  Timer? timer;

  @override
  void onInit() {
    //box.remove(pendingRequests);
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      checkForRequests();
      checkForRequestsExit();
    });
    super.onInit();
  }

  @override
  void dispose() {
    if(timer != null)
      timer!.cancel();
    super.dispose();
  }

  void checkForRequests() async {
    var value = await box.read(pendingRequests);
    if(value != null){
      pendingRequestsModel = PendingRequestsModel.fromJson(jsonDecode(jsonEncode(value)));
    }

    if(pendingRequestsModel.requests.length > 0){
      for(var i = 0; i < pendingRequestsModel.requests.length;i++) {
        VehicleEntryModel vehicleEntryModel = VehicleEntryModel.fromJson(jsonDecode(pendingRequestsModel.requests[i]));
        await executeRequests(vehicleEntryModel, i);
      }
    }
  }

  void checkForRequestsExit() async {
    var value = await box.read(pendingRequestsExit);
    if(value != null){
      pendingRequestsModelExit = PendingRequestsModel.fromJson(jsonDecode(jsonEncode(value)));
    }

    if(pendingRequestsModelExit.requests.length > 0){
      for(var i = 0; i < pendingRequestsModelExit.requests.length;i++) {
        ExitVehiclePostModel vehicleEntryModel = ExitVehiclePostModel.fromJson(jsonDecode(pendingRequestsModel.requests[i]));
        await executeRequestsExit(vehicleEntryModel, i);
      }
    }
  }

  Future<bool> executeRequests(VehicleEntryModel entryModel, position) async {
    VehicleApis apis = VehicleApis();
    Response response = await apis.enterVehicle(entryModel.token, entryModel.toJson());
    print(response.body);
    if(response.statusCode == 201){
      DevicesModel devicesModel = DevicesModel.fromJson(jsonDecode(jsonEncode(response.body)));
      if(devicesModel.status == 200){
        pendingRequestsModel.requests.removeAt(position);
        await box.write(pendingRequests, pendingRequestsModel.toJson());
      }
    }
    return true;
  }

  Future<bool> executeRequestsExit(ExitVehiclePostModel exitVehiclePostModel, position) async {
    VehicleApis apis = VehicleApis();
    Response response = await apis.exitVehicle(exitVehiclePostModel.token, exitVehiclePostModel.toJson());
    print(response.body);
    if(response.statusCode == 201){
      DevicesModel devicesModel = DevicesModel.fromJson(jsonDecode(jsonEncode(response.body)));
      if(devicesModel.status == 200){
        pendingRequestsModelExit.requests.removeAt(position);
        await box.write(pendingRequestsExit, pendingRequestsModelExit.toJson());
      }
    }
    return true;
  }

  void addRequest(Map<String, dynamic> json) async {
    pendingRequestsModel.requests.add(jsonEncode(json));
    await box.write(pendingRequests, pendingRequestsModel.toJson());
  }

  void addRequestExit(Map<String, dynamic> jsonToken) async {
    pendingRequestsModelExit.requests.add(jsonEncode(json));
    await box.write(pendingRequestsExit, pendingRequestsModelExit.toJson());
  }

}
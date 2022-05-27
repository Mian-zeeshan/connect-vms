import 'package:connect_vms/Models/VehicleDataModel.dart';

class VehicleEntryModel {
  String enterTime = "";
  String visitLocationID = "";
  String? enterDeviceType;
  String vehicleTypeID = "";
  String? rFIDCardNo;
  String driverName = "";
  String? driverCNIC;
  String? vehicleNumber;
  List<VehicleDataModel> vehicleData = [];
  String? token;

  VehicleEntryModel(
      {required this.enterTime,
        required this.visitLocationID,
        this.enterDeviceType,
        required this.vehicleTypeID,
        this.rFIDCardNo,
        required this.driverName,
        this.driverCNIC,
        this.vehicleNumber,
        required this.vehicleData});

  VehicleEntryModel.fromJson(Map<String, dynamic> json) {
    enterTime = json['EnterTime'];
    visitLocationID = json['VisitLocationID'];
    enterDeviceType = json['EnterDeviceType'];
    vehicleTypeID = json['VehicleTypeID'];
    rFIDCardNo = json['RFID_CardNo'];
    driverName = json['DriverName'];
    driverCNIC = json['DriverCNIC'];
    vehicleNumber = json['VehicleNumber'];
    token = json['token'];
    if (json['VehicleData'] != null) {
      vehicleData = <VehicleDataModel>[];
      json['VehicleData'].forEach((v) {
        vehicleData.add(new VehicleDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EnterTime'] = this.enterTime;
    data['VisitLocationID'] = this.visitLocationID;
    data['EnterDeviceType'] = this.enterDeviceType;
    data['VehicleTypeID'] = this.vehicleTypeID;
    data['RFID_CardNo'] = this.rFIDCardNo;
    data['DriverName'] = this.driverName;
    data['DriverCNIC'] = this.driverCNIC;
    data['VehicleNumber'] = this.vehicleNumber;
    data['VehicleData'] = this.vehicleData.map((v) => v.toJson()).toList();

    return data;
  }

  Map<String, dynamic> toJsonToken() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EnterTime'] = this.enterTime;
    data['VisitLocationID'] = this.visitLocationID;
    data['EnterDeviceType'] = this.enterDeviceType;
    data['VehicleTypeID'] = this.vehicleTypeID;
    data['RFID_CardNo'] = this.rFIDCardNo;
    data['DriverName'] = this.driverName;
    data['DriverCNIC'] = this.driverCNIC;
    data['VehicleNumber'] = this.vehicleNumber;
    data['token'] = this.token;
    data['VehicleData'] = this.vehicleData.map((v) => v.toJson()).toList();

    return data;
  }
}
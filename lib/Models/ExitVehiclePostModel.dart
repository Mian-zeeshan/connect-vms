import 'package:connect_vms/Models/VehicleDataModel.dart';

class ExitVehiclePostModel {
  String exitTime = "";
  String exitDeviceType = "exit";
  String driverName = "";
  String driverCNIC = "";
  String vehicleNo = "";
  String entryTime = "";
  int recNo = 0;
  int charges = 0;
  List<VehicleDataModel> vehicleData = [];
  String? token;

  ExitVehiclePostModel(
      {required this.exitTime,
        required this.exitDeviceType,
        required this.recNo,
        required this.charges,
        required this.vehicleData});

  ExitVehiclePostModel.fromJson(Map<String, dynamic> json) {
    exitTime = json['ExitTime'];
    exitDeviceType = json['ExitDeviceType'];
    recNo = json['RecNo'];
    charges = json['Charges'];
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
    data['ExitTime'] = this.exitTime;
    data['ExitDeviceType'] = this.exitDeviceType;
    data['RecNo'] = this.recNo;
    data['Charges'] = this.charges;
    data['VehicleData'] = this.vehicleData.map((v) => v.toJson()).toList();
    return data;
  }

  Map<String, dynamic> toJsonToken() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ExitTime'] = this.exitTime;
    data['ExitDeviceType'] = this.exitDeviceType;
    data['RecNo'] = this.recNo;
    data['Charges'] = this.charges;
    data['token'] = this.token;
    data['VehicleData'] = this.vehicleData.map((v) => v.toJson()).toList();
    return data;
  }
}
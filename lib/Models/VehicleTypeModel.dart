import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class VehicleTypeModel {
  int status = 400;
  bool error = true;
  String messages = "Something went wrong please check your internet connection";
  List<VehicleTypeItemModel> data = [];

  VehicleTypeModel({required this.status, required this.error, required this.messages, required this.data});

  VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status']??400;
    error = json['error']??true;
    messages = json['messages']??"Something went wrong please check your internet connection";
    if (json['data'] != null) {
      data = <VehicleTypeItemModel>[];
      json['data'].forEach((v) {
        data.add(new VehicleTypeItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['messages'] = this.messages;
    data['data'] = this.data.map((v) => v.toJson()).toList();

    return data;
  }
}

class VehicleTypeItemModel {
  String? gateId;
  String? gateName;
  String? vehicletypeId;
  String? vehicletypeName;
  String? vehicleTypeIcon;
  Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  VehicleTypeItemModel(
      {this.gateId,
        this.gateName,
        this.vehicletypeId,
        this.vehicletypeName,
        this.vehicleTypeIcon});

  VehicleTypeItemModel.fromJson(Map<String, dynamic> json) {
    gateId = json['gate_id'];
    gateName = json['gate_name'];
    vehicletypeId = json['vehicletype_id'];
    vehicletypeName = json['vehicletype_name'];
    vehicleTypeIcon = json['Vehicle_Type_Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gate_id'] = this.gateId;
    data['gate_name'] = this.gateName;
    data['vehicletype_id'] = this.vehicletypeId;
    data['vehicletype_name'] = this.vehicletypeName;
    data['Vehicle_Type_Icon'] = this.vehicleTypeIcon;
    return data;
  }
}
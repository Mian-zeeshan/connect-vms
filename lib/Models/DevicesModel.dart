class DevicesModel {
  int status = 400;
  bool error = true;
  String? messages;
  List<DevicesItemModel> data = [];

  DevicesModel({required this.status, required this.error, this.messages, required this.data});

  DevicesModel.fromJson(Map<String, dynamic> json) {
    status = json['status']??400;
    error = json['error']??true;
    messages = json['messages'];
    if (json['data'] != null) {
      data = <DevicesItemModel>[];
      json['data'].forEach((v) {
        data.add(new DevicesItemModel.fromJson(v));
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

class DevicesItemModel {
  String deviceId = "";
  String deviceName = "";
  String deviceType = "";
  String? snapType;
  String deviceIp = "";
  String devicePort = "";
  String? isactive;
  String? gateId;
  String? createdDate;
  String? createdBy;
  String? editedDate;
  String? editedTime;

  DevicesItemModel(
      {required this.deviceId,
        required this.deviceName,
        required this.deviceType,
        this.snapType,
        required this.deviceIp,
        required this.devicePort,
        this.isactive,
        this.gateId,
        this.createdDate,
        this.createdBy,
        this.editedDate,
        this.editedTime});

  DevicesItemModel.fromJson(Map<String, dynamic> json) {
    deviceId = json['device_id']??"1";
    deviceName = json['device_name']??"Camera";
    deviceType = json['device_type']??"Camera";
    snapType = json['snap_type'];
    deviceIp = json['device_ip']??"192.168.100.108";
    devicePort = json['device_port']??"1234";
    isactive = json['isactive'];
    gateId = json['gate_id'];
    createdDate = json['created_date'];
    createdBy = json['created_by'];
    editedDate = json['edited_date'];
    editedTime = json['edited_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_id'] = this.deviceId;
    data['device_name'] = this.deviceName;
    data['device_type'] = this.deviceType;
    data['snap_type'] = this.snapType;
    data['device_ip'] = this.deviceIp;
    data['device_port'] = this.devicePort;
    data['isactive'] = this.isactive;
    data['gate_id'] = this.gateId;
    data['created_date'] = this.createdDate;
    data['created_by'] = this.createdBy;
    data['edited_date'] = this.editedDate;
    data['edited_time'] = this.editedTime;
    return data;
  }
}


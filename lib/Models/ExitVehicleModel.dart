class ExitVehicleModel {
  int status = 400;
  bool error = true;
  String? messages;
  String inTime = "2021-10-12 12:00:00 AM";
  String driverName = "";
  String? driverCNIC;
  String? rFIDNo;
  String? vehicleNo;
  String? recNo;
  String? vehicleType;
  int totalFare = 0;

  ExitVehicleModel(
      {required this.status,
        required this.error,
        this.messages,
        required this.inTime,
        required this.driverName,
        this.driverCNIC,
        this.rFIDNo,
        this.vehicleNo,
        this.recNo,
        this.vehicleType,
        required this.totalFare});

  ExitVehicleModel.fromJson(Map<String, dynamic> json) {
    status = json['status']??400;
    error = json['error']??true;
    messages = json['messages'];
    inTime = json['InTime']??"";
    driverName = json['DriverName']??"";
    driverCNIC = json['DriverCNIC'];
    rFIDNo = json['RFIDNo'];
    vehicleNo = json['VehicleNo'];
    recNo = json['RecNo'];
    vehicleType = json['VehicleType'];
    totalFare = json['TotalFare']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['messages'] = this.messages;
    data['InTime'] = this.inTime;
    data['DriverName'] = this.driverName;
    data['DriverCNIC'] = this.driverCNIC;
    data['RFIDNo'] = this.rFIDNo;
    data['VehicleNo'] = this.vehicleNo;
    data['RecNo'] = this.recNo;
    data['VehicleType'] = this.vehicleType;
    data['TotalFare'] = this.totalFare;
    return data;
  }
}
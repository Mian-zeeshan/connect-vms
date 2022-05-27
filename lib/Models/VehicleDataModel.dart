
class VehicleDataModel {
  String imageType = "";
  String imageData = "";

  VehicleDataModel({required this.imageType, required this.imageData});

  VehicleDataModel.fromJson(Map<String, dynamic> json) {
    imageType = json['ImageType'];
    imageData = json['ImageData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ImageType'] = this.imageType;
    data['ImageData'] = this.imageData;
    return data;
  }
}
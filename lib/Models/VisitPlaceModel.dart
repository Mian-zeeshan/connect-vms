class VisitPlaceModel {
  int status  = 400;
  bool error = true;
  String? messages;
  List<VisitPlaceItemModel> data = [];

  VisitPlaceModel({required this.status, required this.error, this.messages, required this.data});

  VisitPlaceModel.fromJson(Map<String, dynamic> json) {
    status = json['status']??400;
    error = json['error']??true;
    messages = json['messages'];
    if (json['data'] != null) {
      data = <VisitPlaceItemModel>[];
      json['data'].forEach((v) {
        data.add(new VisitPlaceItemModel.fromJson(v));
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

class VisitPlaceItemModel {
  String? id;
  String? plotNumber;
  String? phoneNumber;
  String? title;
  String? address;
  String? contactPerson;

  VisitPlaceItemModel(
      {this.id,
        this.plotNumber,
        this.phoneNumber,
        this.title,
        this.address,
        this.contactPerson});

  VisitPlaceItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plotNumber = json['PlotNumber'];
    phoneNumber = json['PhoneNumber'];
    title = json['Title'];
    address = json['Address'];
    contactPerson = json['ContactPerson'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PlotNumber'] = this.plotNumber;
    data['PhoneNumber'] = this.phoneNumber;
    data['Title'] = this.title;
    data['Address'] = this.address;
    data['ContactPerson'] = this.contactPerson;
    return data;
  }
}


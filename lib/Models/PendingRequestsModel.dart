class PendingRequestsModel {
  List<String> requests = [];

  PendingRequestsModel({required this.requests});

  PendingRequestsModel.fromJson(Map<String, dynamic> json) {
    if(json["requests"] != null)
    requests = json['requests'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requests'] = this.requests;
    return data;
  }
}


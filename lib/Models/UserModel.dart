class UserModel {
  int status = 500;
  bool error = false;
  String? messages;
  String token = "";
  String userId = "";
  String? name;
  String? gateId;
  String? gateName;
  String? gateType;

  UserModel(
      {required this.status,
        required this.error,
        this.messages,
        required this.token,
        required this.userId,
        this.name,
        this.gateId,
        this.gateName,
        this.gateType});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status']??200;
    error = json['error']??false;
    messages = json['messages'];
    token = json['token']??"";
    userId = json['user_id']??"0";
    name = json['name'];
    gateId = json['gate_id'];
    gateName = json['gate_name'];
    gateType = json['gate_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['messages'] = this.messages;
    data['token'] = this.token;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['gate_id'] = this.gateId;
    data['gate_name'] = this.gateName;
    data['gate_type'] = this.gateType;
    return data;
  }
}
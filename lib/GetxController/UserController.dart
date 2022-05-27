import 'dart:convert';

import 'package:connect_vms/Models/UserModel.dart';
import 'package:connect_vms/Views/auth_screens/LoginScreen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../AppConstants/Constants.dart';

class UserController extends GetxController{
  UserModel? userModel;
  var box = GetStorage();

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  void getUser() async {
    var value = await box.read(currentUser);
    print(value);
    if(value != null){
      userModel = UserModel.fromJson(jsonDecode(jsonEncode(value)));
      update(["0"]);
      notifyChildrens();
    }else{
      Get.offAll(()=> LoginScreen());
    }
  }
}
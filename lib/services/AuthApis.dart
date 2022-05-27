import 'package:connect_vms/AppConstants/Constants.dart';
import 'package:get/get.dart';

class AuthApis extends GetConnect{
  //login Api

  Future<Response> login(data)=> post("$apiUrl/api/login",data);

}
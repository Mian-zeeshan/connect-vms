import 'package:connect_vms/AppConstants/Constants.dart';
import 'package:get/get.dart';

class VehicleApis extends GetConnect{

  Future<Response> getVehicleType(token) => get("$apiUrl/api/vehicletypesbygateid", headers: {"Authorization" : token});

  Future<Response> getCameras(token) => get("$apiUrl/api/devicesbygateid", headers: {"Authorization" : token});

  Future<Response> GetVisitTypes(token) => get("$apiUrl/api/getvisitingplaces", headers: {"Authorization" : token});

  Future<Response> enterVehicle(token, data){
    httpClient.timeout = Duration(seconds: 30);
    httpClient.followRedirects = true;
    return post("$apiUrl/api/trafficin", data, headers: {"Authorization" : token});
  }

  Future<Response> exitVehicle(token, data){
    httpClient.timeout = Duration(seconds: 30);
    httpClient.followRedirects = true;
    return post("$apiUrl/api/trafficout", data, headers: {"Authorization" : token});
  }

  Future<Response> getVehicleById(token, data){
    httpClient.timeout = Duration(seconds: 30);
    httpClient.followRedirects = true;
    return post("$apiUrl/api/getvehicle", data, headers: {"Authorization" : token});
  }

}
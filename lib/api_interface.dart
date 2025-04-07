import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:prubea1app/control_variables.dart';
import 'package:prubea1app/db/api_call.dart';
import 'package:prubea1app/db/models/user.dart';

Future<Response<dynamic>> login(String email, String password) async {
  APICall apiCall = APICall();
  Response<dynamic> response = await apiCall.client.post(
    '$API_ENDPOINT/user/login',
    data: jsonEncode({'email': email, 'password': password}),
  );
  return response;
}

Future<Response<dynamic>> logout() async {
  APICall apiCall = APICall();
  final response = await apiCall.client.post('$API_ENDPOINT/user/logout');
  return response;
}

Future<dynamic> getUserDashboard() async {
  APICall apiCall = APICall();
  final response = await apiCall.client.post(
    '$API_ENDPOINT/user/get-dashboard-data',
  );

  if (response.data["type"] == "customer") {
    print(response.data);
    return CustomerPreview.fromJson(response.data);
  }
  return AdminPreview.fromJson(response.data);
}

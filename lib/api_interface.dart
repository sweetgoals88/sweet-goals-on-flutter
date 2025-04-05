import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:prubea1app/control_variables.dart';
import 'package:prubea1app/db/api_call.dart';
import 'package:prubea1app/db/api_response_models/user_dashboard.dart';

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
    return CustomerDashboardPayload.fromJson(response.data);
  }
  return AdminDashboardPayload.fromJson(response.data);

  // {"id":"yIloyvvIETdf06ZhWz0d","name":"Ulises Eduardo","surname":"López Acosta","email":"eduardola.ti23@utsjr.edu.mx","type":"customer","notifications":[],"oldestNotification":null,"prototypes":[{"id":"BTSSmx22yKDgC1a9yAIQ","operational":true,"version_id":"IZ3mEGXP1dOb8Xyr94O8","user_customization":{"icon":"default","label":"default","latitude":0,"longitude":0},"panel_specifications":{},"internalReadings":[],"externalReadings":[],"oldestInternalReading":null,"oldestExternalReading":null}]}
}

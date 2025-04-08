import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:prubea1app/api/api_call.dart';
import 'dart:convert';

import 'package:prubea1app/control_variables.dart';
import 'package:prubea1app/db/location_option.dart';
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

Future<List<LocationOption>> geocode(String query) async {
  APICall apiCall = APICall();
  final response = await apiCall.client.get(
    '$API_ENDPOINT/geocoding',
    queryParameters: {"query": query},
  );
  return (response.data != null ? response.data as List : List.empty())
      .map((data) => LocationOption.fromJson(data))
      .toList();
}

Future<void> validateActivationCode(String activationCode) async {
  APICall apiCall = APICall();
  await apiCall.client.get(
    "$API_ENDPOINT/prototype/validate-is-new-prototype",
    queryParameters: {"activationCode": activationCode},
  );
}

Future<void> signupCustomer({
  required String name,
  required String surname,
  required String email,
  required String password,
  required String activationCode,
  required double latitude,
  required double longitude,
  required String label,
  required int numberOfPanels,
  required double peakVoltage,
  required double temperatureRate,
}) async {
  APICall apiCall = APICall();
  await apiCall.client.post(
    "$API_ENDPOINT/user/register",
    data: jsonEncode({
      "name": name,
      "surname": surname,
      "email": email,
      "password": password,
      "type": "customer",
      "activation_code": activationCode,
      "user_customization": {
        "latitude": latitude,
        "longitude": longitude,
        "label": label,
        "icon": "default",
      },
      "panel_specifications": {
        "number_of_panels": numberOfPanels,
        "peak_voltage": peakVoltage,
        "temperature_rate": temperatureRate,
      },
    }),
  );
}

Future<void> updateUserProfile({
  required String name,
  required String surname,
  required String email,
  required String newPassword,
  required String oldPassword,
}) async {
  APICall apiCall = APICall();
  try {
    await apiCall.client.post(
      "$API_ENDPOINT/user/edit-profile",
      data: {
        "name": name,
        "surname": surname,
        "email": email,
        "newPassword": newPassword,
        "oldPassword": oldPassword,
      },
    );
  } catch (e) {
    throw Exception("Error al actualizar el perfil: $e");
  }
}

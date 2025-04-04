import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:http/http.dart' as dio;
import 'package:prubea1app/control_variables.dart';
import 'package:prubea1app/db/api_call.dart';

class ApiInterface {
  static Future<Response<dynamic>> login(String email, String password) async {
    try {
      APICall apiCall = APICall();
      final response = await apiCall.client.post(
        '$API_ENDPOINT/user/login',
        data: jsonEncode({'email': email, 'password': password}),
      );
      print('Respuesta de autenticación: ${response.data}');
      return response;
    } catch (e) {
      print('Error en la autenticación: $e');
      throw e;
    }
  }

  static Future<Response<dynamic>> logout() async {
    APICall apiCall = APICall();
    final response = await apiCall.client.post(
      '$API_ENDPOINT/user/logout',
    );
    return response;
  }
}

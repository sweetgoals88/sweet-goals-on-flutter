import 'package:flutter/material.dart';
import 'package:prubea1app/db/api_response_models/user_dashboard.dart';

class DashboardDataProvider extends ChangeNotifier {
  final dynamic data;

  DashboardDataProvider({required this.data});

  bool isCustomerData() {
    return data["type"] == "customer";
  }

  bool isAdminData() {
    return data["type"] == "admin";
  }

  CustomerDashboardPayload asCustomer() {
    return data as CustomerDashboardPayload;
  }

  AdminDashboardPayload asAdmin() {
    return data as AdminDashboardPayload;
  }
}

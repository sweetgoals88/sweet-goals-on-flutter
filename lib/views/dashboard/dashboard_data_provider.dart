import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prubea1app/db/api_response_models/user_dashboard.dart';

class DashboardDataProvider extends ChangeNotifier {
  final dynamic data;
  Timer? _timer;

  DashboardDataProvider({required this.data});

  bool isCustomerData() {
    return data is CustomerDashboardPayload;
  }

  bool isAdminData() {
    return data is AdminDashboardPayload;
  }

  CustomerDashboardPayload asCustomer() {
    return data as CustomerDashboardPayload;
  }

  AdminDashboardPayload asAdmin() {
    return data as AdminDashboardPayload;
  }

  void _startFetching() {
    //
  }

  Future<void> _fetchData() async {
    try {
      // final response = await api.getUserDashboard();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

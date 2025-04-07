import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prubea1app/db/models/user.dart';

class DashboardDataProvider extends ChangeNotifier {
  final dynamic data;
  Timer? _timer;

  DashboardDataProvider({required this.data});

  bool isCustomerData() {
    return data is CustomerPreview;
  }

  bool isAdminData() {
    return data is AdminPreview;
  }

  CustomerPreview asCustomer() {
    return data as CustomerPreview;
  }

  AdminPreview asAdmin() {
    return data as AdminPreview;
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

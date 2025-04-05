import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prubea1app/views/dashboard/admin_dashboard/admin_dashboard.dart';
import 'package:prubea1app/views/dashboard/customer_dashboard/customer_dashboard.dart';
import 'package:prubea1app/views/dashboard/dashboard_data_provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardDataProvider>(context);
    if (provider.isAdminData()) {
      return AdminDashboard();
    } else if (provider.isCustomerData()) {
      return CustomerDashboard();
    } else {
      throw Exception("Invalid user type");
    }
  }
}

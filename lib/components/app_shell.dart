import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:prubea1app/api_interface.dart' as api;
import 'package:prubea1app/views/dashboard/dashboard_data_provider.dart';
import 'package:prubea1app/components/loading_state.dart';

class AppShell extends StatefulWidget {
  StatefulNavigationShell statefulNavigationShell;

  AppShell({super.key, required this.statefulNavigationShell});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late Future<dynamic> _userDashboardPayload;

  @override
  void initState() {
    super.initState();
    _userDashboardPayload = api.getUserDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userDashboardPayload,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingState();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return ChangeNotifierProvider(
          create: (_) => DashboardDataProvider(data: snapshot.data),
          child: Scaffold(
            appBar: AppBar(title: Text("Solar Sync"), centerTitle: true),
            body: Container(
              color: Colors.white,
              child: widget.statefulNavigationShell,
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.only(bottom: 5),
              child: GNav(
                color: Colors.black,
                activeColor: Colors.black,
                tabBackgroundColor: Colors.white.withAlpha(76),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                onTabChange: (index) {
                  widget.statefulNavigationShell.goBranch(index);
                },
                tabs: const [
                  GButton(icon: Icons.dashboard, iconActiveColor: Colors.black),
                  GButton(
                    icon: Icons.notifications,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(icon: Icons.person, iconActiveColor: Colors.black),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

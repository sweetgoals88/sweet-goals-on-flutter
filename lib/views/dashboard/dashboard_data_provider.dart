import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prubea1app/api/api_interface.dart' as api;
import 'package:prubea1app/db/models/external_reading.dart';
import 'package:prubea1app/db/models/internal_reading.dart';
import 'package:prubea1app/db/models/prototype.dart';
import 'package:prubea1app/db/models/user.dart';

class DashboardDataProvider extends ChangeNotifier {
  dynamic data;
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

  void setUser(final String name, final String surname, final String email) {
    if (isCustomerData()) {
      data = CustomerPreview(
        id: data.id,
        name: name,
        surname: surname,
        email: email,
        type: data.type,
        notifications: data.notifications,
        oldestNotification: data.oldestNotification,
        prototypes: data.prototypes,
      );
    } else if (isAdminData()) {
      data = AdminPreview(
        id: data.id,
        name: name,
        surname: surname,
        email: email,
        type: data.type,
        adminCode: data.adminCode,
        permissions: data.permissions,
        invitedAdmins: data.invitedAdmins,
        notifications: data.notifications,
        lastNotification: data.lastNotification,
      );
    }
    notifyListeners();
  }

  UserPreview asUser() {
    if (isCustomerData()) {
      return UserPreview.fromCustomer(asCustomer());
    } else {
      return UserPreview.fromAdmin(asAdmin());
    }
  }

  Future<void> fetchPrototypeReadings() async {
    try {
      if (!isCustomerData()) return;

      final customerData = asCustomer();

      // Fetch readings for all prototypes in parallel
      final responses = await Future.wait(
        customerData.prototypes.map((prototype) async {
          final response = await api.getLastReadings(
            lastInternalReading: prototype.oldestInternalReading,
            lastExternalReading: prototype.oldestExternalReading,
            prototypeId: prototype.id,
          );
          return {"prototype": prototype, "response": response};
        }),
      );

      // Update prototypes with the fetched readings
      final updatedPrototypes =
          responses.map((result) {
            final prototype = result["prototype"] as PrototypePreview;
            final response =
                result["response"]
                    as ({
                      List<ExternalReadingPreview> externalReadings,
                      List<InternalReadingPreview> internalReadings,
                      String? nextLastExternalReading,
                      String? nextLastInternalReading,
                    });

            // Combine and sort readings, keeping only the 20 most recent
            final updatedInternalReadings =
                [...response.internalReadings, ...prototype.internalReadings]
                  ..sort((a, b) => a.dateTime.compareTo(b.dateTime))
                  ..take(20);

            final updatedExternalReadings =
                [...response.externalReadings, ...prototype.externalReadings]
                  ..sort((a, b) => a.dateTime.compareTo(b.dateTime))
                  ..take(20);

            return PrototypePreview(
              id: prototype.id,
              operational: prototype.operational,
              versionId: prototype.versionId,
              userCustomization: prototype.userCustomization,
              panelSpecifications: prototype.panelSpecifications,
              internalReadings: updatedInternalReadings,
              externalReadings: updatedExternalReadings,
              oldestInternalReading: response.nextLastInternalReading,
              oldestExternalReading: response.nextLastExternalReading,
            );
          }).toList();

      // Update the customer data with the updated prototypes
      data = CustomerPreview(
        id: customerData.id,
        name: customerData.name,
        surname: customerData.surname,
        email: customerData.email,
        type: customerData.type,
        notifications: customerData.notifications,
        oldestNotification: customerData.oldestNotification,
        prototypes: updatedPrototypes,
      );

      notifyListeners();
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

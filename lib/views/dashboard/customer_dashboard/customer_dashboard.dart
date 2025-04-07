import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:prubea1app/db/models/prototype.dart';
import 'package:prubea1app/views/dashboard/dashboard_data_provider.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  PrototypePreview? selectedPrototype;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<DashboardDataProvider>(context);
    if (selectedPrototype == null &&
        provider.data?.prototypes.isNotEmpty == true) {
      selectedPrototype = provider.data!.prototypes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardDataProvider>(context);
    final data = provider.asCustomer();
    final prototypes = data.prototypes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown
          DropdownButton<PrototypePreview>(
            value: selectedPrototype,
            isExpanded: true,
            items:
                prototypes.map((proto) {
                  return DropdownMenuItem(
                    value: proto,
                    child: Text(proto.userCustomization.label),
                  );
                }).toList(),
            onChanged: (proto) {
              setState(() => selectedPrototype = proto);
            },
          ),
          const SizedBox(height: 16),

          // Panel Specifications
          if (selectedPrototype != null) ...[
            Text(
              "Panel Specs: ${selectedPrototype!.panelSpecifications.numberOfPanels} panels, "
              "${selectedPrototype!.panelSpecifications.peakVoltage}V peak, "
              "Temp rate: ${selectedPrototype!.panelSpecifications.temperatureRate}",
            ),
            const SizedBox(height: 8),
            Text(
              "User Location: (${selectedPrototype!.userCustomization.latitude}, "
              "${selectedPrototype!.userCustomization.longitude})",
            ),
            const SizedBox(height: 24),

            // External Readings Chart
            Text(
              "External Readings",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 200,
              child: _buildExternalChart(selectedPrototype!),
            ),
            const SizedBox(height: 24),

            // Internal Readings Chart
            Text(
              "Internal Readings",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 200,
              child: _buildInternalChart(selectedPrototype!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExternalChart(PrototypePreview prototype) {
    final data = prototype.externalReadings;

    final spotsCurrent =
        data
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.current,
              ),
            )
            .toList();
    final spotsVoltage =
        data
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.voltage,
              ),
            )
            .toList();
    final spotsWattage =
        data
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.wattage,
              ),
            )
            .toList();

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spotsCurrent,
            color: Colors.blue,
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: spotsVoltage,
            color: Colors.red,
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: spotsWattage,
            color: Colors.green,
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildInternalChart(PrototypePreview prototype) {
    final data = prototype.internalReadings;

    final spotsHumidity =
        data
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.humidity,
              ),
            )
            .toList();
    final spotsTemperature =
        data
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.temperature,
              ),
            )
            .toList();

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spotsHumidity,
            color: Colors.purple,
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: spotsTemperature,
            color: Colors.orange,
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

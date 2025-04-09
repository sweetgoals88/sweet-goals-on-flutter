import 'dart:math';

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
    final customerData = provider.asCustomer();

    if (selectedPrototype == null && customerData.prototypes.isNotEmpty) {
      selectedPrototype = customerData.prototypes.first;
    }
  }

  Widget _buildDropdown(List<PrototypePreview> prototypes) {
    return DropdownButton<PrototypePreview>(
      value: selectedPrototype,
      onChanged: (PrototypePreview? newValue) {
        setState(() {
          selectedPrototype = newValue;
        });
      },
      items:
          prototypes.map<DropdownMenuItem<PrototypePreview>>((prototype) {
            return DropdownMenuItem<PrototypePreview>(
              value: prototype,
              child: Text(prototype.userCustomization.label),
            );
          }).toList(),
    );
  }

  Widget _buildLineChart({
    required List<FlSpot> spots,
    required String title,
    required String unit,
    required Color color,
    required double minY,
    required double maxY,
    required double maxX,
    required double minX,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title ($unit)", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  color: color,
                  isCurved: false,
                  dotData: FlDotData(show: false),
                ),
              ],
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
            ),
            curve: Curves.linear,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardDataProvider>(context);
    final customerData = provider.asCustomer();

    if (selectedPrototype == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final internalData = selectedPrototype!.internalReadings;
    internalData.sort(
      (a, b) =>
          (a.dateTime.millisecondsSinceEpoch.toDouble() -
                  b.dateTime.millisecondsSinceEpoch.toDouble())
              .toInt(),
    );

    final externalData = selectedPrototype!.externalReadings;
    externalData.sort(
      (a, b) =>
          (a.dateTime.millisecondsSinceEpoch.toDouble() -
                  b.dateTime.millisecondsSinceEpoch.toDouble())
              .toInt(),
    );

    final internalDataTimestamps = internalData.map(
      (e) => e.dateTime.millisecondsSinceEpoch.toDouble(),
    );
    final externalDataTimestamps = externalData.map(
      (e) => e.dateTime.millisecondsSinceEpoch.toDouble(),
    );

    final minInternalTimestamp =
        internalDataTimestamps.isNotEmpty
            ? internalDataTimestamps.reduce(min)
            : 0.0;
    final maxInternalTimestamp =
        internalDataTimestamps.isNotEmpty
            ? internalDataTimestamps.reduce(max)
            : 100.0;

    final minExternalTimestamp =
        externalDataTimestamps.isNotEmpty
            ? externalDataTimestamps.reduce(min)
            : 0.0;
    final maxExternalTimestamp =
        externalDataTimestamps.isNotEmpty
            ? externalDataTimestamps.reduce(max)
            : 100.0;

    final spotsTemperature =
        internalData
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.temperature,
              ),
            )
            .toList();

    final spotsHumidity =
        internalData
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.humidity,
              ),
            )
            .toList();

    final spotsCurrent =
        externalData
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.current,
              ),
            )
            .toList();

    final spotsVoltage =
        externalData
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.voltage,
              ),
            )
            .toList();

    final spotsPower =
        externalData
            .map(
              (e) => FlSpot(
                e.dateTime.millisecondsSinceEpoch.toDouble(),
                e.wattage,
              ),
            )
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Seleccionar prototipo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildDropdown(customerData.prototypes),
          const SizedBox(height: 16),
          Text(
            "Ubicación: ${selectedPrototype!.userCustomization.locationName}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Especificaciones: ${selectedPrototype!.panelSpecifications.numberOfPanels} paneles, "
            "Voltaje pico: ${selectedPrototype!.panelSpecifications.peakVoltage}V, "
            "Tasa de temperatura: ${selectedPrototype!.panelSpecifications.temperatureRate}°C",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _buildLineChart(
            spots: spotsTemperature,
            title: "Temperatura",
            unit: "°C",
            color: Colors.orange,
            minY: -10,
            maxY: 40,
            minX: minInternalTimestamp,
            maxX: maxInternalTimestamp,
          ),
          _buildLineChart(
            spots: spotsHumidity,
            title: "Humedad",
            unit: "%",
            color: Colors.blue,
            minY: 0,
            maxY: 100,
            minX: minInternalTimestamp,
            maxX: maxInternalTimestamp,
          ),
          _buildLineChart(
            spots: spotsCurrent,
            title: "Corriente",
            unit: "A",
            color: Colors.green,
            minY: 0,
            maxY: 100,
            minX: minExternalTimestamp,
            maxX: maxExternalTimestamp,
          ),
          _buildLineChart(
            spots: spotsVoltage,
            title: "Voltaje",
            unit: "V",
            color: Colors.red,
            minY: -100,
            maxY: 150,
            minX: minExternalTimestamp,
            maxX: maxExternalTimestamp,
          ),
          _buildLineChart(
            spots: spotsPower,
            title: "Potencia",
            unit: "W",
            color: Colors.purple,
            minY: -3000,
            maxY: 1000,
            minX: minExternalTimestamp,
            maxX: maxExternalTimestamp,
          ),
        ],
      ),
    );
  }
}

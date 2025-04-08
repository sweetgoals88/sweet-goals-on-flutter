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

  Widget _buildLineChart(
    List<FlSpot> spots,
    String title,
    String unit,
    Color color,
    double minY,
    double maxY,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title ($unit)", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
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
                  isCurved: true,
                  dotData: FlDotData(show: false),
                ),
              ],
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
            ),
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
    final externalData = selectedPrototype!.externalReadings;

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
            spotsTemperature,
            "Temperatura",
            "°C",
            Colors.orange,
            -10,
            40,
          ),
          _buildLineChart(spotsHumidity, "Humedad", "%", Colors.blue, 0, 100),
          _buildLineChart(spotsCurrent, "Corriente", "A", Colors.green, 0, 100),
          _buildLineChart(spotsVoltage, "Voltaje", "V", Colors.red, 0, 150),
          _buildLineChart(spotsPower, "Potencia", "W", Colors.purple, 0, 1000),
        ],
      ),
    );
  }
}

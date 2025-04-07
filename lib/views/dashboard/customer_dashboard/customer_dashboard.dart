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
          // Otros datos como voltage y wattage
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
          // Otros datos como temperature
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ...existing code...

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ...existing code...

          // External Readings Chart
          Text(
            "External Readings",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 200, child: _buildExternalChart(selectedPrototype!)),
          const SizedBox(height: 8),
          _buildExternalChartLegend(), // Leyenda para el gráfico externo
          const SizedBox(height: 24),

          // Internal Readings Chart
          Text(
            "Internal Readings",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 200, child: _buildInternalChart(selectedPrototype!)),
          const SizedBox(height: 8),
          _buildInternalChartLegend(), // Leyenda para el gráfico interno
        ],
      ),
    );
  }

  // Leyenda para el gráfico externo
  Widget _buildExternalChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.blue, "Corriente"),
        _buildLegendItem(Colors.red, "Voltaje"),
        _buildLegendItem(Colors.green, "Potencia"),
      ],
    );
  }

  // Leyenda para el gráfico interno
  Widget _buildInternalChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.purple, "Humedad"),
        _buildLegendItem(Colors.orange, "Temperatura"),
      ],
    );
  }

  // Widget reutilizable para un ítem de la leyenda
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

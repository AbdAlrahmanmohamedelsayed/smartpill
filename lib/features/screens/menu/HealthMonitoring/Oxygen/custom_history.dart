import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/oximeterData.dart';

class VitalsHistoryWidget extends StatelessWidget {
  final List<VitalsMeasurement> measurements;
  final Function(VitalsMeasurement)? onItemTap;

  const VitalsHistoryWidget({
    super.key,
    required this.measurements,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (measurements.isEmpty) {
      return const Center(
        child: Text('No measurements recorded yet'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Measurements',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${measurements.length} records',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: measurements.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              final measurement = measurements[index];
              return MeasurementCard(
                measurement: measurement,
                onTap: onItemTap != null ? () => onItemTap!(measurement) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

// Individual measurement card
class MeasurementCard extends StatelessWidget {
  final VitalsMeasurement measurement;
  final VoidCallback? onTap;

  const MeasurementCard({
    super.key,
    required this.measurement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine oxygen level status and color
    Color oxygenColor = AppColor.primaryColor;
    if (measurement.oxygenLevel < 90) {
      oxygenColor = Colors.red;
    } else if (measurement.oxygenLevel < 95) {
      oxygenColor = Colors.orange;
    }

    // Determine heart rate status and color
    Color heartRateColor = Colors.green;
    if (measurement.heartRate > 100 || measurement.heartRate < 60) {
      heartRateColor = Colors.red;
    } else if (measurement.heartRate > 90 || measurement.heartRate < 65) {
      heartRateColor = Colors.orange;
    }

    return Card(
      color: AppColor.whiteColor,
      borderOnForeground: true,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColor.whiteColor,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Date and time header
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColor.primaryColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          measurement.formattedDate,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey[700],
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          measurement.formattedTime,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Measurements display
              Row(
                children: [
                  // Oxygen level
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: oxygenColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.healing,
                                color: oxygenColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Oxygen',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${measurement.oxygenLevel.toStringAsFixed(1)}%',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: oxygenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Heart rate
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: heartRateColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: heartRateColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Heart Rate',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${measurement.heartRate} BPM',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: heartRateColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (onTap != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'View Details',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColor.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColor.primaryColor,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

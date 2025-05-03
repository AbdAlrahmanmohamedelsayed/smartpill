import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/DrugAlternative.dart';

class AlternativeCard extends StatelessWidget {
  final DrugAlternative alternative;

  const AlternativeCard({
    Key? key,
    required this.alternative,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: AppColor.whiteColor,
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shadowColor: AppColor.primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side:
            BorderSide(color: AppColor.primaryColor.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side with image and shadow
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  'assets/images/icons/drugs.png',
                  width: 50,
                  height: 50,
                ),
              ),
              const SizedBox(width: 16),
              // Right side with information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alternative.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                        fontSize: 22,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.category_outlined,
                      label: 'Composition:',
                      text: alternative.composition,
                      theme: theme,
                      isExpandable: true,
                    ),
                    _buildInfoRow(
                      icon: Icons.medication,
                      label: 'Class:',
                      text: alternative.className,
                      theme: theme,
                    ),
                    _buildInfoRow(
                      icon: Icons.business,
                      label: 'Company:',
                      text: alternative.company,
                      theme: theme,
                      isExpandable: true,
                    ),
                    const Divider(height: 24),
                    _buildPriceRow(
                      theme: theme,
                      price: alternative.price,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String text,
    required ThemeData theme,
    bool isExpandable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColor.primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  overflow: isExpandable
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                  maxLines: isExpandable ? 2 : 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required ThemeData theme,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Price:',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          Text(
            price,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

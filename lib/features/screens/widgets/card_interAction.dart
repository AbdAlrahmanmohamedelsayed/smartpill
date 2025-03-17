import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/drug_interaction.dart';

// ignore: must_be_immutable
class CardInteractionView extends StatelessWidget {
  DrugInteraction interactiondat;

  CardInteractionView({required this.interactiondat, super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var meia = MediaQuery.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      height: meia.size.height * .4,
      width: meia.size.width * 0.30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.errorColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(3, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  interactiondat.drug1,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColor.textColorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/icons/exchange.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Text(
                  interactiondat.drug2,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColor.textColorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColor.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              interactiondat.interactionType,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColor.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            interactiondat.effect,
            maxLines: 3,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColor.errorColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

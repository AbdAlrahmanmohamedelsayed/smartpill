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
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      height: meia.size.height * .4,
      width: meia.size.width * 0.30,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.accentGreen, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(interactiondat.drug1,
                  maxLines: 2,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColor.textColorPrimary)),
              Image.asset(width: 70, 'assets/images/icons/versus.png'),
              Text(interactiondat.drug2,
                  maxLines: 2,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColor.textColorPrimary)),
            ],
          ),
          Text(interactiondat.interactionType,
              style: theme.textTheme.bodyMedium),
          Text(
            maxLines: 2,
            interactiondat.effect,
            style: theme.textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}

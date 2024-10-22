import 'package:eshop/design/units.dart';
import 'package:flutter/material.dart';

import '../../design/design.dart';

class OtherItemCard extends StatelessWidget {
  final String title;
  final Function()? onClick;
  final IconData icon;
  const OtherItemCard({
    Key? key,
    required this.title,
    this.onClick,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Units.edgeInsetsXXXLarge,
          right: Units.edgeInsetsXXXLarge,
          bottom: Units.edgeInsetsMedium,
          top: Units.edgeInsetsSmall),
      child: InkWell(
        borderRadius: BorderRadius.circular(Units.radiusXXXXXLarge),
        onTap: onClick,
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Units.radiusXXXXXLarge),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Colours.colorsButtonMenu.withOpacity(0.45),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Units.edgeInsetsLarge,
                vertical: Units.edgeInsetsXXXLarge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.interMediumBody1,
                ),
                Icon(icon, color: Colours.colorsButtonMenu),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

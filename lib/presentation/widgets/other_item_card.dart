import 'package:flutter/material.dart';

import '../../design/design.dart';

class OtherItemCard extends StatelessWidget {
  final String title;
  final Function()? onClick;
  const OtherItemCard({
    Key? key,
    required this.title,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 4, top: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onClick,
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

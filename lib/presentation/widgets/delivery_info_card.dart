import 'package:eshop/core/extension/string_extension.dart';
import 'package:eshop/design/colours.dart';
import 'package:eshop/design/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/design.dart';
import '../../domain/entities/user/delivery_info.dart';
import '../blocs/delivery_info/delivery_info_action/delivery_info_action_cubit.dart';
import '../views/main/other/delivery_info/delivery_info.dart';
import 'outline_label_card.dart';

class DeliveryInfoCard extends StatelessWidget {
  final DeliveryInfo? deliveryInformation;
  final bool isSelected;
  const DeliveryInfoCard(
      {Key? key, this.deliveryInformation, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (deliveryInformation != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            context
                .read<DeliveryInfoActionCubit>()
                .selectDeliveryInfo(deliveryInformation!);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Units.radiusXXXXXLarge),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding:
                const EdgeInsets.symmetric(vertical: Units.edgeInsetsXLarge),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(Units.edgeInsetsLarge),
                  child: Icon(
                    Icons.edit_location,
                    color: Colours.colorsButtonMenu,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${deliveryInformation!.firstName} ${deliveryInformation!.lastName}, ${deliveryInformation!.contactNumber}",
                        style: TextStyles.interRegularBody1.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${deliveryInformation!.addressLineOne}, ${deliveryInformation!.addressLineTwo}, ${deliveryInformation!.city}, ${deliveryInformation!.zipCode}",
                        style: TextStyles.interBoldBody2.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: Units.edgeInsetsMedium),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Units.radiusXXXXXXLarge),
                              ),
                              builder: (BuildContext context) {
                                return DeliveryInfoForm(
                                  deliveryInfo: deliveryInformation,
                                );
                              },
                            );
                          },
                          child: Text(
                            "Edit",
                            style: TextStyles.interRegularBody2.copyWith(
                              color: Colours.colorsButtonMenu,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: Units.sizedbox_25,
                  child: Center(
                    child: isSelected
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Units.radiusXXXXXXXXXXLarge),
                              color: Colours.colorsButtonMenu,
                            ),
                          )
                        : const SizedBox(),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: Units.edgeInsetsXLarge),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(Units.radiusXXXXLarge),
            ),
            child: Container(
              padding: const EdgeInsets.only(
                  top: Units.edgeInsetsXXLarge, bottom: Units.edgeInsetsLarge),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(Units.edgeInsetsLarge),
                    child: Icon(Icons.edit_location),
                  ),
                  const SizedBox(
                    width: Units.sizedbox_5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: Units.edgeInsetsXXXLarge),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Units.radiusXXXXLarge),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Units.radiusXXXXLarge),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 14,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Units.radiusXXXXLarge),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 18,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Units.radiusXXXXLarge),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: Units.sizedbox_5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

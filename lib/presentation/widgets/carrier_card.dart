import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/domain/entities/carrier.dart';
import 'package:eshop/presentation/blocs/carrier/carrier_action/carrier_action_cubit.dart';
import 'package:eshop/presentation/widgets/outline_label_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CarrierCard extends StatelessWidget {
  final Carrier? carrier;
  final bool isSelected;
  const CarrierCard(
      {super.key, required this.carrier, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    if (carrier != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            context.read<CarrierActionCubit>().selectCarrier(carrier!);
          },
          child: OutlineLabelCard(
            title: '',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   SizedBox(
                     child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                        imageUrl: carrier!.photo,
                                    ),
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
                          carrier!.name,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          carrier!.description,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                    
                      ],
                    ),
                  ),    SizedBox(
                          width: 25,
                          child: Center(
                            child: isSelected
                                ? Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(42),
                                      color: Colors.black87,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      );
    }else {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.edit_location),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
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
                              borderRadius: BorderRadius.circular(12),
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
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
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

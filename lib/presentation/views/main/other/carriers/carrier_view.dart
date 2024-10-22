import 'package:eshop/core/constant/images.dart';
import 'package:eshop/presentation/blocs/carrier/carrier_action/carrier_action_cubit.dart';
import 'package:eshop/presentation/blocs/carrier/carrier_info/carrier_fetch_cubit.dart';
import 'package:eshop/presentation/widgets/carrier_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../../design/design.dart';

class CarrierView extends StatefulWidget {
  const CarrierView({Key? key}) : super(key: key);

  @override
  State<CarrierView> createState() => _CarrierViewState();
}

class _CarrierViewState extends State<CarrierView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CarrierActionCubit, CarrierActionState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is CarrierActionLoading) {
          EasyLoading.show(status: 'loading...');
        } else if (state is CarrierSelectActionSuccess) {
          context.read<CarrierFetchCubit>().selectCarrier(state.carrier);
        } else if (state is CarrierActionFail) {
          EasyLoading.showError('Failed to select carrier');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Carrier Details'),
        ),
        body: BlocBuilder<CarrierFetchCubit, CarrierFetchState>(
          builder: (context, state) {
            if (state is! CarrierFetchLoading && state.carriers.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kEmptyDeliveryInfo),
                  const Text("Delivery information are Empty!"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              );
            }
            return ListView.builder(
              itemCount:
                  (state is CarrierActionLoading && state.carriers.isEmpty)
                      ? 5
                      : state.carriers.length,
              padding: const EdgeInsets.symmetric(
                  horizontal: Units.edgeInsetsXXXLarge,
                  vertical: Units.edgeInsetsXLarge),
              itemBuilder: (context, index) =>
                  (state is CarrierActionLoading && state.carriers.isEmpty)
                      ? const CarrierCard(carrier: null, isSelected: false)
                      : CarrierCard(
                          carrier: state.carriers[index],
                          isSelected:
                              state.selectedCarrier == state.carriers[index],
                        ),
            );
          },
        ),
      ),
    );
  }
}

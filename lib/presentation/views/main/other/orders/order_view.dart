import 'package:eshop/design/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/images.dart';
import '../../../../../design/design.dart';
import '../../../../blocs/order/order_fetch/order_fetch_cubit.dart';
import '../../../../widgets/order_info_card.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: BlocBuilder<OrderFetchCubit, OrderFetchState>(
        builder: (context, state) {
          if (state is! OrderFetchLoading && state.orders.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(kOrderDelivery),
                const Text("Orders are Empty!",
                    style: TextStyles.interRegularBody1),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                )
              ],
            );
          }
          if (state is OrderFetchSuccess) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.orders.length,
              padding: EdgeInsets.only(
                left: Units.edgeInsetsXXLarge,
                right: Units.edgeInsetsXXLarge,
                bottom: (Units.edgeInsetsXXLarge +
                    MediaQuery.of(context).padding.bottom),
                top: Units.edgeInsetsXXLarge,
              ),
              itemBuilder: (context, index) => OrderInfoCard(
                orderDetails: state.orders[index],
              ),
            );
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 6,
              padding: EdgeInsets.only(
                left: Units.edgeInsetsXXLarge,
                right: Units.edgeInsetsXXLarge,
                bottom: (Units.edgeInsetsXXLarge +
                    MediaQuery.of(context).padding.bottom),
                top: Units.edgeInsetsXXLarge,
              ),
              itemBuilder: (context, index) => const OrderInfoCard(),
            );
          }
        },
      ),
    );
  }
}

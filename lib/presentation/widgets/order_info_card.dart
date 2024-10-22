import 'package:eshop/design/units.dart';
import 'package:eshop/presentation/blocs/order/order_fetch/order_fetch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/design.dart';
import '../../domain/entities/order/order_details.dart';
import 'OrderDetailsPage.dart';

class OrderInfoCard extends StatefulWidget {
  final OrderDetails? orderDetails;
  const OrderInfoCard({Key? key, this.orderDetails}) : super(key: key);

  @override
  State<OrderInfoCard> createState() => _OrderInfoCardState();
}

class _OrderInfoCardState extends State<OrderInfoCard> {
  @override
  void initState() {
    super.initState();
    context.read<OrderFetchCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orderDetails != null) {
      final totalPrice = widget.orderDetails!.orderItems.fold(
          0.0,
          (previousValue, element) =>
              previousValue + (element.totalPrice * element.quantity));

      return Padding(
        padding: const EdgeInsets.only(bottom: Units.edgeInsetsXXLarge),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    OrderDetailsPage(orderDetails: widget.orderDetails!),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long,
                            color: Colours.colorsButtonMenu),
                        const SizedBox(width: Units.sizedbox_8),
                        Text(
                          "Order ID: ${widget.orderDetails!.id}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    _buildStatusBadge(widget.orderDetails!.status),
                  ],
                ),
                const Divider(height: 24, color: Colours.colorsButtonMenu),
                _buildInfoRow(Icons.shopping_cart, "Items",
                    "${widget.orderDetails!.orderItems.length}"),
                _buildInfoRow(
                    Icons.location_on_sharp,
                    "Address",
                    "${widget.orderDetails!.shippingAdress.addressLineOne}"
                        "${widget.orderDetails!.shippingAdress.addressLineTwo}"),
                _buildInfoRow(Icons.location_city, "Ville",
                    widget.orderDetails!.shippingAdress.city),
                _buildInfoRow(Icons.calendar_today, "Date",
                    widget.orderDetails!.orderDate),
                _buildInfoRow(Icons.attach_money, "Total",
                    "\$${(totalPrice / 100).toStringAsFixed(2)}"),
              ],
            ),
          ),
        ),
      );
    } else {
      return _buildShimmerLoading();
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Units.edgeInsetsMedium),
      child: Row(
        children: [
          Icon(icon, color: Colours.colorsButtonMenu),
          const SizedBox(width: Units.sizedbox_8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyles.interRegularBody1.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Units.edgeInsetsXXLarge,
          vertical: Units.edgeInsetsMedium),
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
      child: Text(
        status ?? "Unknown",
        style: TextStyles.interSemiBoldTiny.copyWith(
          color: Colours.colorsButtonMenu,
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Units.edgeInsetsXXLarge),
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
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Units.edgeInsetsXXLarge,
                horizontal: Units.edgeInsetsXLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Units.radiusXXLarge),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: Units.sizedbox_8),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Units.radiusXXLarge),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: Units.sizedbox_8),
                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Units.radiusXXLarge),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: Units.sizedbox_10),
                Container(
                  height: 14,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Units.radiusXXLarge),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}

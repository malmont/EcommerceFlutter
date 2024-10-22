import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/design.dart';
import '../../domain/entities/order/order_details.dart';
import 'OrderDetailsPage.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderDetails? orderDetails;
  const OrderInfoCard({Key? key, this.orderDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orderDetails != null) {
      final totalPrice = orderDetails!.orderItems.fold(
          0.0,
          (previousValue, element) =>
              previousValue + (element.totalPrice * element.quantity));

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    OrderDetailsPage(orderDetails: orderDetails!),
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
                        const SizedBox(width: 8),
                        Text(
                          "Order ID: ${orderDetails!.id}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    _buildStatusBadge(orderDetails!.status),
                  ],
                ),
                Divider(height: 24, color: Colours.colorsButtonMenu),
                _buildInfoRow(Icons.shopping_cart, "Items",
                    "${orderDetails!.orderItems.length}"),
                _buildInfoRow(
                    Icons.location_on_sharp,
                    "Address",
                    "${orderDetails!.shippingAdress.addressLineOne}"
                        "${orderDetails!.shippingAdress.addressLineTwo}"),
                _buildInfoRow(Icons.location_city, "Ville",
                    orderDetails!.shippingAdress.city),
                _buildInfoRow(
                    Icons.calendar_today, "Date", orderDetails!.orderDate),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colours.colorsButtonMenu),
          const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
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
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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

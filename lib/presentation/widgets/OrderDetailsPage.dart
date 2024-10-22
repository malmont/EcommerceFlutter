import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/design/design.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/order/order_details.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderDetails orderDetails;

  const OrderDetailsPage({Key? key, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details - ${orderDetails.id}",
            style: TextStyles.interBoldBody2.copyWith(
              color: Colors.black,
            )),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Units.edgeInsetsXXLarge),
        child: GridView.builder(
          itemCount: orderDetails.orderItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.40,
          ),
          itemBuilder: (context, index) {
            final product = orderDetails.orderItems[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Units.radiusXXXXXLarge),
              ),
              elevation: 6,
              shadowColor: Colors.black12,
              child: InkWell(
                borderRadius: BorderRadius.circular(Units.radiusXXXXXLarge),
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(Units.radiusXXXXXLarge)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        imageUrl: product.productImage,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey.shade200),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.redAccent),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productVariantName,
                            style: TextStyles.interBoldBody1.copyWith(
                              color: Colours.colorsButtonMenu,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: Units.sizedbox_8),
                          Row(
                            children: [
                              const Icon(Icons.attach_money,
                                  color: Colours.colorsButtonMenu, size: 20),
                              const SizedBox(width: Units.edgeInsetsMedium),
                              Text(
                                  '\$${(product.totalPrice / 100).toStringAsFixed(2)}',
                                  style: TextStyles.interRegularBody2),
                            ],
                          ),
                          const SizedBox(height: Units.edgeInsetsMedium),
                          Row(
                            children: [
                              const Icon(Icons.swap_horizontal_circle_sharp,
                                  color: Colours.colorsButtonMenu, size: 20),
                              const SizedBox(width: Units.edgeInsetsMedium),
                              Text('Size: ${product.productVariantSize}',
                                  style: TextStyles.interRegularBody2),
                            ],
                          ),
                          const SizedBox(height: Units.edgeInsetsMedium),
                          Row(
                            children: [
                              const Icon(Icons.colorize,
                                  color: Colours.colorsButtonMenu, size: 20),
                              const SizedBox(width: Units.edgeInsetsMedium),
                              Text('Color: ${product.productVariantColor}',
                                  style: TextStyles.interRegularBody2),
                            ],
                          ),
                          const SizedBox(height: Units.edgeInsetsMedium),
                          Row(
                            children: [
                              const Icon(Icons.shopping_bag,
                                  color: Colours.colorsButtonMenu, size: 20),
                              const SizedBox(width: Units.edgeInsetsMedium),
                              Text('Quantity: ${product.quantity}',
                                  style: TextStyles.interRegularBody2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

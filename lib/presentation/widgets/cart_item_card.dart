import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';
import 'package:eshop/design/design.dart';
import 'package:eshop/domain/entities/cart/cart_item.dart';
import 'package:eshop/presentation/blocs/cart/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final Function? onClick;
  final Function()? onLongClick;

  const CartItemCard({
    Key? key,
    required this.cartItem,
    this.onClick,
    this.onLongClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onClick as void Function()?,
        onLongPress: onLongClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 70,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: cartItem.product.image,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.white,
                      child: Container(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: Text(
                      cartItem.product.name.length > 13
                          ? '${cartItem.product.name.substring(0, 13)}...'
                          : cartItem.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.interBoldBody2.copyWith(
                        color: Colours.colorsButtonMenu,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    child: Row(
                      children: [
                        Text(
                          '\$${(cartItem.product.price / 100).toStringAsFixed(2)}',
                          style: TextStyles.interRegularBody1,
                        ),
                        const SizedBox(width: Units.sizedbox_10),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Units.sizedbox_10),
                          Wrap(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Units.edgeInsetsXLarge,
                                    vertical: Units.edgeInsetsLarge),
                                margin: const EdgeInsets.all(
                                    Units.edgeInsetsMedium),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      Units.radiusXXLarge),
                                ),
                                child: Text(
                                    cartItem.variant.size.name.substring(0, 1)),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Units.sizedbox_10),
                          Wrap(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(
                                    Units.edgeInsetsMedium),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(int.parse(
                                          cartItem.variant.color.codeHexa
                                              .replaceFirst('#', ''),
                                          radix: 16) +
                                      0xFF000000),
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context
                        .read<CartBloc>()
                        .add(AddProduct(cartItem: cartItem));
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colours.colorsButtonMenu,
                    ),
                  ),
                ),
                const SizedBox(width: Units.sizedbox_10),
                Text(
                  '${cartItem.quantity}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: Units.sizedbox_10),
                GestureDetector(
                  onTap: () {
                    context
                        .read<CartBloc>()
                        .add(RemoveProduct(cartItem: cartItem));
                  },
                  child: Container(
                    width: Units.u32,
                    height: Units.u32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: const Icon(
                      Icons.remove,
                      size: 20,
                      color: Colours.colorsButtonMenu,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

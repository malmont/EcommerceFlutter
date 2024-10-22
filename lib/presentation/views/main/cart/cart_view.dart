import 'package:eshop/core/router/app_router.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';
import 'package:eshop/domain/entities/cart/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../design/design.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../widgets/cart_item_card.dart';
import '../../../widgets/input_form_button.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<CartItem> selectedCartItems = [];
  String _getTotalItems(List<CartItem> cart) {
    int totalItems = cart.fold(0, (sum, item) => sum + item.quantity);
    return 'Total ($totalItems items)';
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        if (state is CartError && state.cart.isEmpty) {
                          return const Center(child: Text('Cart is Empty'));
                        }
                        if (state.cart.isEmpty) {
                          return const Center(child: Text('Cart is Empty'));
                        }
                        return ListView.builder(
                          itemCount: state.cart.length,
                          padding: EdgeInsets.only(
                              top: (MediaQuery.of(context).padding.top + 20),
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 200),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final cartItem = state.cart[index];
                            return CartItemCard(
                              cartItem: cartItem,
                              onLongClick: () {
                                setState(() {
                                  if (selectedCartItems.any((element) =>
                                      element.product.id ==
                                      cartItem.product.id)) {
                                    selectedCartItems.removeWhere((element) =>
                                        element.product.id ==
                                        cartItem.product.id);
                                  } else {
                                    selectedCartItems.add(cartItem);
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              if (state.cart.isEmpty) {
                return const SizedBox();
              }
              return Positioned(
                bottom: (MediaQuery.of(context).padding.bottom + 90),
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<CartBloc>().add(const ClearCart());
                        },
                        style: CustomButtonStyle.customButtonStyle(
                            type: ButtonType.validButton,
                            isSelected: isSelected),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Clear Cart',
                          style: TextStyles.interRegularBody1.copyWith(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, left: 8, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total items: ${state.totalItems}',
                                  style:
                                      TextStyles.interRegularBody1.copyWith(),
                                ),
                                Text(
                                    '\$${(state.cart.fold(0.0, (previousValue, element) => (element.product.price * element.quantity) + previousValue) / 100).toStringAsFixed(2)}',
                                    style: TextStyles.interBoldBody2.copyWith(
                                      color: Colours.colorsButtonMenu,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 100,
                            child: ElevatedButton(
                              style: CustomButtonStyle.customButtonStyle(
                                  type: ButtonType.selectedButton,
                                  isSelected: isSelected),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    AppRouter.orderCheckout,
                                    arguments: state.cart);
                              },
                              child: const Text(
                                'Checkout',
                                style: TextStyles.interRegularBody1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

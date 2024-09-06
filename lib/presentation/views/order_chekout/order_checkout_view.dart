import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/core/extension/string_extension.dart';
import 'package:eshop/domain/entities/order/order_detail_response.dart';
import 'package:eshop/presentation/blocs/carrier/carrier_info/carrier_fetch_cubit.dart';
import 'package:eshop/presentation/blocs/cart/cart_bloc.dart';
import 'package:eshop/presentation/blocs/home/navbar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../core/services/services_locator.dart' as di;
import '../../../core/router/app_router.dart';
import '../../../domain/entities/cart/cart_item.dart';
import '../../../domain/entities/order/order_details.dart';
import '../../../domain/entities/order/order_item.dart';
import '../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../blocs/order/order_add/order_add_cubit.dart';
import '../../widgets/input_form_button.dart';
import '../../widgets/outline_label_card.dart';

class OrderCheckoutView extends StatelessWidget {
  final List<CartItem> items;
  const OrderCheckoutView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int deliveryCharge = 0;
    return BlocProvider(
      create: (context) => di.sl<OrderAddCubit>(),
      child: BlocListener<OrderAddCubit, OrderAddState>(
        listener: (context, state) {
          EasyLoading.dismiss();
          if (state is OrderAddLoading) {
            EasyLoading.show(status: 'Loading...');
          } else if (state is OrderAddSuccess) {
            context.read<NavbarCubit>().update(0);
            context.read<NavbarCubit>().controller.jumpToPage(0);
            context.read<CartBloc>().add(const ClearCart());
            Navigator.of(context).pop();
            EasyLoading.showSuccess("Order Placed Successfully");
          } else if (state is OrderAddFail) {
            EasyLoading.showError("Error");
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Order Checkout'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 12,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: OutlineLabelCard(
                        title: 'Delivery Details',
                        child: BlocBuilder<DeliveryInfoFetchCubit,
                            DeliveryInfoFetchState>(
                          builder: (context, state) {
                            if (state.deliveryInformation.isNotEmpty &&
                                state.selectedDeliveryInformation != null) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    top: 16, bottom: 12, left: 4, right: 10),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${state.selectedDeliveryInformation!.firstName.capitalize()} ${state.selectedDeliveryInformation!.lastName}, ${state.selectedDeliveryInformation!.contactNumber}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${state.selectedDeliveryInformation!.addressLineOne}, ${state.selectedDeliveryInformation!.addressLineTwo}, ${state.selectedDeliveryInformation!.city}, ${state.selectedDeliveryInformation!.zipCode}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                              );
                            } else {
                              return Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                    top: 20, bottom: 8, left: 4),
                                child: const Text(
                                  "Please select delivery information",
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: -4,
                      top: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRouter.deliveryDetails);
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: OutlineLabelCard(
                        title: 'Carrier Details',
                        child:
                            BlocBuilder<CarrierFetchCubit, CarrierFetchState>(
                          builder: (context, state) {
                            if (state.carriers.isNotEmpty &&
                                state.selectedCarrier != null) {
                              deliveryCharge = state.selectedCarrier!.price;
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      imageUrl: state.selectedCarrier!.photo,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 12,
                                        left: 4,
                                        right: 10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.selectedCarrier!.name
                                                .capitalize(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            state.selectedCarrier!.description,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                    top: 20, bottom: 8, left: 4),
                                child: const Text(
                                  "Please select delivery information",
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: -4,
                      top: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRouter.carrier);
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                OutlineLabelCard(
                  title: 'Selected Products',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8),
                    child: Column(
                      children: items
                          .map((product) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 75,
                                      child: AspectRatio(
                                        aspectRatio: 0.88,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CachedNetworkImage(
                                                imageUrl: product.product.image,
                                              ),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.product.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${(product.product.price / 100).toStringAsFixed(2)}',
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'x${product.quantity}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Affichage de la taille
                                                  Wrap(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        margin: const EdgeInsets
                                                            .all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          product
                                                              .variant.size.name
                                                              .substring(0, 1),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  // Affichage de la couleur
                                                  Wrap(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(4),
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color(int.parse(
                                                                  product
                                                                      .variant
                                                                      .color
                                                                      .codeHexa
                                                                      .replaceFirst(
                                                                          '#',
                                                                          ''),
                                                                  radix: 16) +
                                                              0xFF000000), // Conversion du code hexadécimal en couleur
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                OutlineLabelCard(
                  title: 'Order Summery',
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Number of Items"),
                            BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                              if (state.cart.isEmpty) {
                                return const SizedBox();
                              }

                              return Text("x${state.totalItems}");
                            }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Price"),
                            Text(
                                '\$${(items.fold(0.0, (previousValue, element) => ((element.product.price * element.quantity) + previousValue)) / 100).toStringAsFixed(2)}'),
                          ],
                        ),
                        BlocBuilder<CarrierFetchCubit, CarrierFetchState>(
                          builder: (context, state) {
                            if (state.carriers.isNotEmpty &&
                                state.selectedCarrier != null) {
                              deliveryCharge = state.selectedCarrier!
                                  .price; // Stocker la valeur de livraison
                            } else {
                              deliveryCharge =
                                  499; // Valeur par défaut si aucun transporteur n'est sélectionné
                            }
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Delivery Charge"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${(deliveryCharge / 100).toStringAsFixed(2)}', // Affichage correct du montant
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total"),
                                    Text(
                                        '\$${((items.fold(0.0, (previousValue, element) => (((element.product.price * element.quantity) + previousValue)) + deliveryCharge) / 100)).toStringAsFixed(2)}')
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Builder(builder: (context) {
                return InputFormButton(
                  color: Colors.black87,
                  onClick: () {
                    if (context
                            .read<DeliveryInfoFetchCubit>()
                            .state
                            .selectedDeliveryInformation ==
                        null) {
                      EasyLoading.showError(
                          "Error \nPlease select delivery and add your delivery information");
                    } else {
                      context.read<OrderAddCubit>().addOrder(
                          OrderDetailResponse(
                              orderSource: 3,
                              carrierId: int.parse(context
                                  .read<DeliveryInfoFetchCubit>()
                                  .state
                                  .selectedDeliveryInformation!
                                  .id),
                              paymentMethod: 1,
                              addressId: int.parse(context
                                  .read<DeliveryInfoFetchCubit>()
                                  .state
                                  .selectedDeliveryInformation!
                                  .id),
                              typeOrder: 1,
                              items: items
                                  .map((e) => OrderItemDetail(
                                        productVariantId: e.variant.id,
                                        quantity: e.quantity,
                                      ))
                                  .toList()));

                      context.read<OrderAddCubit>().stream.listen((state) {
                        if (state is OrderAddSuccess) {
                          EasyLoading.showSuccess("Order Placed Successfully");
                          context.read<CartBloc>().add(const ClearCart());
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRouter.home, (Route<dynamic> route) => false);
                        } else if (state is OrderAddFail) {
                          EasyLoading.showError("Error placing order");
                        }
                      });
                    }
                  },
                  titleText: 'Confirm',
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

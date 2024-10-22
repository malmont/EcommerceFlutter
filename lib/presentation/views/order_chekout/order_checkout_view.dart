import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/core/extension/string_extension.dart';
import 'package:eshop/domain/entities/order/order_detail_response.dart';
import 'package:eshop/presentation/blocs/carrier/carrier_info/carrier_fetch_cubit.dart';
import 'package:eshop/presentation/blocs/cart/cart_bloc.dart';
import 'package:eshop/presentation/blocs/home/navbar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/services/services_locator.dart' as di;
import '../../../core/router/app_router.dart';
import '../../../design/design.dart';
import '../../../domain/entities/cart/cart_item.dart';
import '../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../blocs/order/order_add/order_add_cubit.dart';
import '../../widgets/input_form_button.dart';
import '../../widgets/outline_label_card.dart';

class OrderCheckoutView extends StatelessWidget {
  final List<CartItem> items;
  const OrderCheckoutView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    int deliveryCharge = 0;
    double subtotal = items.fold(
            0.0,
            (previousValue, element) =>
                ((element.product.price * element.quantity) + previousValue)) /
        100;
    double tax = (subtotal * 0.05) + (subtotal * 0.10);
    double total = subtotal + (deliveryCharge / 100) + tax;

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
                  Container(
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: OutlineLabelCard(
                            labelStyle: TextStyles.interRegularBody1
                                .copyWith(color: Colours.colorsButtonMenu),
                            title: 'Delivery Details',
                            child: BlocBuilder<DeliveryInfoFetchCubit,
                                DeliveryInfoFetchState>(
                              builder: (context, state) {
                                if (state.deliveryInformation.isNotEmpty &&
                                    state.selectedDeliveryInformation != null) {
                                  return Container(
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
                                              "${state.selectedDeliveryInformation!.firstName.capitalize()} ${state.selectedDeliveryInformation!.lastName}, ${state.selectedDeliveryInformation!.contactNumber}",
                                              style: TextStyles.interBoldBody2),
                                          Text(
                                              "${state.selectedDeliveryInformation!.addressLineOne}, ${state.selectedDeliveryInformation!.addressLineTwo}, ${state.selectedDeliveryInformation!.city}, ${state.selectedDeliveryInformation!.zipCode}",
                                              style:
                                                  TextStyles.interRegularBody1),
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
                              color: Colours.colorsButtonMenu,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: OutlineLabelCard(
                            labelStyle: TextStyles.interRegularBody1
                                .copyWith(color: Colours.colorsButtonMenu),
                            title: 'Carrier Details',
                            child: BlocBuilder<CarrierFetchCubit,
                                CarrierFetchState>(
                              builder: (context, state) {
                                if (state.carriers.isNotEmpty &&
                                    state.selectedCarrier != null) {
                                  deliveryCharge = state.selectedCarrier!.price;
                                  total =
                                      subtotal + (deliveryCharge / 100) + tax;
                                  return Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              state.selectedCarrier!.photo,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.transparent,
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
                                                  style: TextStyles
                                                      .interBoldBody2),
                                              Text(
                                                  state.selectedCarrier!
                                                      .description,
                                                  style: TextStyles
                                                      .interRegularBody1),
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
                              Navigator.of(context)
                                  .pushNamed(AppRouter.carrier);
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colours.colorsButtonMenu,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineLabelCard(
                            labelStyle: TextStyles.interRegularBody1
                                .copyWith(color: Colours.colorsButtonMenu),
                            title: 'Selected Products',
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 18, bottom: 8),
                              child: Column(
                                children: items
                                    .map((product) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 85,
                                                child: AspectRatio(
                                                  aspectRatio: 0.88,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Container(
                                                            width: 70,
                                                            height: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black26,
                                                                  blurRadius:
                                                                      10.0,
                                                                  offset:
                                                                      Offset(
                                                                          0, 5),
                                                                ),
                                                              ],
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    product
                                                                        .product
                                                                        .image,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                                  baseColor: Colors
                                                                      .grey
                                                                      .shade100,
                                                                  highlightColor:
                                                                      Colors
                                                                          .white,
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                  ),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Center(
                                                                        child: Icon(
                                                                            Icons.error)),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
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
                                                      style: TextStyles
                                                          .interBoldBody2,
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            '\$${(product.product.price / 100).toStringAsFixed(2)},',
                                                            style: TextStyles
                                                                .interRegularBody1),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                            'x${product.quantity}',
                                                            style: TextStyles
                                                                .interRegularBody1),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Wrap(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Text(
                                                                    product
                                                                        .variant
                                                                        .size
                                                                        .name
                                                                        .substring(
                                                                            0,
                                                                            1),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Wrap(
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(int.parse(
                                                                            product.variant.color.codeHexa.replaceFirst('#',
                                                                                ''),
                                                                            radix:
                                                                                16) +
                                                                        0xFF000000),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            2),
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
                        ),
                        const Positioned(right: -4, top: 0, child: SizedBox()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineLabelCard(
                            labelStyle: TextStyles.interRegularBody1
                                .copyWith(color: Colours.colorsButtonMenu),
                            title: 'Order Summary',
                            child: Container(
                              height: 150,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Total Number of Items",
                                        style: TextStyles.interBoldBody2,
                                      ),
                                      BlocBuilder<CartBloc, CartState>(
                                          builder: (context, state) {
                                        if (state.cart.isEmpty) {
                                          return const SizedBox();
                                        }

                                        return Text("x${state.totalItems}",
                                            style:
                                                TextStyles.interRegularBody1);
                                      }),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Subtotal",
                                          style: TextStyles.interBoldBody2),
                                      Text('\$${subtotal.toStringAsFixed(2)}',
                                          style: TextStyles.interRegularBody1),
                                    ],
                                  ),
                                  BlocBuilder<CarrierFetchCubit,
                                      CarrierFetchState>(
                                    builder: (context, state) {
                                      if (state.carriers.isNotEmpty &&
                                          state.selectedCarrier != null) {
                                        deliveryCharge =
                                            state.selectedCarrier!.price;
                                      } else {
                                        deliveryCharge =
                                            49; // Valeur par défaut
                                      }
                                      total = subtotal +
                                          (deliveryCharge / 100) +
                                          tax;
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Delivery Charge",
                                                  style: TextStyles
                                                      .interBoldBody2),
                                              Text(
                                                '\$${(deliveryCharge / 100).toStringAsFixed(2)}',
                                                style: TextStyles
                                                    .interRegularBody1,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Tax",
                                                  style: TextStyles
                                                      .interBoldBody2),
                                              Text(
                                                  '\$${tax.toStringAsFixed(2)}',
                                                  style: TextStyles
                                                      .interRegularBody1),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Total",
                                                  style: TextStyles
                                                      .interBoldBody2),
                                              Text(
                                                  '\$${total.toStringAsFixed(2)}',
                                                  style: TextStyles
                                                      .interRegularBody1),
                                            ],
                                          ),
                                          const Positioned(
                                              right: -4,
                                              top: 0,
                                              child: SizedBox()),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Builder(builder: (context) {
                return ElevatedButton(
                  style: CustomButtonStyle.customButtonStyle(
                      type: ButtonType.selectedButton, isSelected: isSelected),
                  child: const Text('Place Order'),
                  onPressed: () {
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
                              addressId: int.parse(context
                                  .read<DeliveryInfoFetchCubit>()
                                  .state
                                  .selectedDeliveryInformation!
                                  .id),
                              paymentMethod: 1,
                              carrierId: int.parse(context
                                  .read<CarrierFetchCubit>()
                                  .state
                                  .selectedCarrier!
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
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

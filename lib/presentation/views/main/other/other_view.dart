import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/design/units.dart';
import 'package:eshop/presentation/blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import 'package:eshop/presentation/blocs/order/order_fetch/order_fetch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/images.dart';
import '../../../../core/router/app_router.dart';
import '../../../../design/design.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../widgets/other_item_card.dart';

class OtherView extends StatelessWidget {
  const OtherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Units.edgeInsetsXXXLarge,
                vertical: Units.edgeInsetsXLarge),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLogged) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRouter.userProfile,
                        arguments: state.user,
                      );
                    },
                    child: Row(
                      children: [
                        state.user.image != null
                            ? CachedNetworkImage(
                                imageUrl: state.user.image!,
                                imageBuilder: (context, image) => CircleAvatar(
                                  radius: Units.radiusXXXXXXXXXLarge,
                                  backgroundImage: image,
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            : const CircleAvatar(
                                radius: Units.radiusXXXXXXXXXLarge,
                                backgroundImage: AssetImage(kUserAvatar),
                                backgroundColor: Colors.transparent,
                              ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${state.user.firstName} ${state.user.lastName}",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(state.user.email)
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRouter.signIn);
                    },
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: Units.radiusXXXXXXXXXLarge,
                          backgroundImage: AssetImage(kUserAvatar),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: Units.sizedbox_12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login in your account",
                              style: TextStyles.interBoldBody1,
                            ),
                            Text("")
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return OtherItemCard(
                icon: Icons.person,
                onClick: () {
                  if (state is UserLogged) {
                    Navigator.of(context).pushNamed(
                      AppRouter.userProfile,
                      arguments: state.user,
                    );
                  } else {
                    Navigator.of(context).pushNamed(AppRouter.signIn);
                  }
                },
                title: "Profile",
              );
            },
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLogged) {
                return Padding(
                  padding: const EdgeInsets.only(top: Units.edgeInsetsLarge),
                  child: OtherItemCard(
                    icon: Icons.shopping_bag,
                    onClick: () {
                      Navigator.of(context).pushNamed(AppRouter.orders);
                    },
                    title: "Orders",
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLogged) {
                return Padding(
                  padding: const EdgeInsets.only(top: Units.edgeInsetsLarge),
                  child: OtherItemCard(
                    onClick: () {
                      Navigator.of(context)
                          .pushNamed(AppRouter.deliveryDetails);
                    },
                    title: "Delivery Info",
                    icon: Icons.local_shipping,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: Units.sizedbox_5),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLogged) {
                return Padding(
                  padding: const EdgeInsets.only(top: Units.edgeInsetsLarge),
                  child: OtherItemCard(
                    icon: Icons.local_shipping,
                    onClick: () {
                      Navigator.of(context).pushNamed(AppRouter.carrier);
                    },
                    title: "Carrier Info",
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: Units.sizedbox_8),
          OtherItemCard(
            icon: Icons.settings,
            onClick: () {
              Navigator.of(context).pushNamed(AppRouter.settings);
            },
            title: "Settings",
          ),
          const SizedBox(height: Units.sizedbox_8),
          OtherItemCard(
            icon: Icons.info,
            onClick: () {
              Navigator.of(context).pushNamed(AppRouter.about);
            },
            title: "About",
          ),
          const SizedBox(height: Units.sizedbox_8),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLogged) {
                return OtherItemCard(
                  icon: Icons.logout,
                  onClick: () {
                    context.read<UserBloc>().add(SignOutUser());
                    context.read<CartBloc>().add(const ClearCart());
                    context
                        .read<DeliveryInfoFetchCubit>()
                        .clearLocalDeliveryInfo();
                    context.read<OrderFetchCubit>().clearLocalOrders();
                  },
                  title: "Sign Out",
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          SizedBox(
              height:
                  (MediaQuery.of(context).padding.bottom + Units.sizedbox_50)),
        ],
      ),
    );
  }
}

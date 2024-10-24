import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/images.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_router.dart';
import '../../../../design/design.dart';
import '../../../../domain/usecases/product/get_product_usecase.dart';
import '../../../blocs/filter/filter_cubit.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../widgets/alert_card.dart';
import '../../../widgets/input_form_button.dart';
import '../../../widgets/product_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController scrollController = ScrollController();

  void _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    double scrollPercentage = 0.7;

    if (currentScroll > (maxScroll * scrollPercentage)) {
      if (context.read<ProductBloc>().state is ProductLoaded &&
          !context.read<ProductBloc>().isFetching) {
        final state = context.read<ProductBloc>().state as ProductLoaded;
        if (state.metaData.total > state.products.length) {
          print("Déclenchement de GetMoreProducts");
          context.read<ProductBloc>().add(const GetMoreProducts());
        } else {
          print("Tous les produits ont été chargés");
        }
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colours.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: (MediaQuery.of(context).padding.top + 10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child:
                  BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                if (state is UserLogged) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRouter.userProfile);
                        },
                        child: Text(
                          "${state.user.firstName} ${state.user.lastName}",
                          style: TextStyles.interItalicH5,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.userProfile,
                            arguments: state.user,
                          );
                        },
                        child: state.user.image != null
                            ? CachedNetworkImage(
                                imageUrl: state.user.image!,
                                imageBuilder: (context, image) => CircleAvatar(
                                  radius: Units.radiusXXXXXXLarge,
                                  backgroundImage: image,
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            : const CircleAvatar(
                                radius: Units.radiusXXXXXXLarge,
                                backgroundImage: AssetImage(kUserAvatar),
                                backgroundColor: Colors.transparent,
                              ),
                      )
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Units.sizedbox_8,
                          ),
                          Text(
                            "Welcome,",
                            style: TextStyles.interItalicH5,
                          ),
                          Text(
                            "E-Shop mobile store",
                            style: TextStyles.interItalicH5,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRouter.signIn);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: Units.radiusXXXXXXLarge,
                            backgroundImage: AssetImage(kUserAvatar),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      )
                    ],
                  );
                }
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: Units.radiusXXXXLarge,
                left: Units.edgeInsetsXXXLarge,
                right: Units.edgeInsetsXXXLarge,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<FilterCubit, FilterProductParams>(
                      builder: (context, state) {
                        return TextField(
                          autofocus: false,
                          controller:
                              context.read<FilterCubit>().searchController,
                          onChanged: (val) => setState(() {}),
                          onSubmitted: (val) => context.read<ProductBloc>().add(
                              GetProducts(FilterProductParams(keyword: val))),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: Units.edgeInsetsXXLarge,
                                  bottom: Units.edgeInsetsXXXLarge,
                                  top: Units.edgeInsetsXXXLarge),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(
                                    left: Units.edgeInsetsLarge),
                                child: Icon(
                                  Icons.search,
                                  color: Colours.colorsButtonMenu,
                                ),
                              ),
                              suffixIcon: context
                                      .read<FilterCubit>()
                                      .searchController
                                      .text
                                      .isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          right: Units.edgeInsetsLarge),
                                      child: IconButton(
                                          onPressed: () {
                                            context
                                                .read<FilterCubit>()
                                                .searchController
                                                .clear();
                                            context
                                                .read<FilterCubit>()
                                                .update(keyword: '');
                                          },
                                          icon: const Icon(Icons.clear)),
                                    )
                                  : null,
                              border: const OutlineInputBorder(),
                              hintText: "Search Product",
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colours.colorsButtonMenu,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(16)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Colours.colorsButtonMenu,
                                    width: 1.0),
                              )),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 55,
                    child: BlocBuilder<FilterCubit, FilterProductParams>(
                      builder: (context, state) {
                        return Badge(
                          alignment: AlignmentDirectional.topEnd,
                          label: Text(
                            context
                                .read<FilterCubit>()
                                .getFiltersCount()
                                .toString(),
                            style: const TextStyle(color: Colors.black87),
                          ),
                          isLabelVisible:
                              context.read<FilterCubit>().getFiltersCount() !=
                                  0,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: InputFormButton(
                            color: Colors.black87,
                            onClick: () {
                              Navigator.of(context).pushNamed(AppRouter.filter);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Units.edgeInsetsLarge),
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoaded && state.products.isEmpty) {
                      return const AlertCard(
                        image: kEmpty,
                        message: "Products not found!",
                      );
                    }
                    if (state is ProductError && state.products.isEmpty) {
                      if (state.failure is NetworkFailure) {
                        return AlertCard(
                          image: kNoConnection,
                          message: "Network failure\nTry again!",
                          onClick: () {
                            context.read<ProductBloc>().add(GetProducts(
                                FilterProductParams(
                                    keyword: context
                                        .read<FilterCubit>()
                                        .searchController
                                        .text)));
                          },
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.failure is ServerFailure)
                            Image.asset(
                                'assets/status_image/internal-server-error.png'),
                          if (state.failure is CacheFailure)
                            Image.asset(
                                'assets/status_image/no-connection.png'),
                          const Text("Products not found!"),
                          IconButton(
                            onPressed: () {
                              context.read<ProductBloc>().add(GetProducts(
                                  FilterProductParams(
                                      keyword: context
                                          .read<FilterCubit>()
                                          .searchController
                                          .text)));
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                        ],
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<ProductBloc>()
                            .add(const GetProducts(FilterProductParams()));
                      },
                      child: GridView.builder(
                        itemCount: state.products.length +
                            ((state is ProductLoading) ? 10 : 0),
                        controller: scrollController,
                        padding: EdgeInsets.only(
                          top: Units.edgeInsetsXXLarge,
                          left: Units.edgeInsetsXXLarge,
                          right: Units.edgeInsetsXXLarge,
                          bottom: (80 + MediaQuery.of(context).padding.bottom),
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 20,
                        ),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          if (state.products.length > index) {
                            return ProductCard(
                              product: state.products[index],
                            );
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.white,
                              child: const ProductCard(),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoaded &&
                    state.products.length >= state.metaData.total) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Tous les produits ont été chargés.",
                        style: TextStyles.interRegularBody1,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

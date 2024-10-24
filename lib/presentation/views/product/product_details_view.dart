import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/design/units.dart';
import 'package:eshop/domain/entities/product/variant.dart';
import 'package:eshop/presentation/blocs/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../domain/entities/cart/cart_item.dart';
import '../../../../../domain/entities/product/product.dart';

import '../../../design/design.dart';
import '../../blocs/cart/cart_bloc.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;

  const ProductDetailsView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentIndex = 0;
  String? selectedColor;
  String? selectedSize;

  late ProductBloc productBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productBloc = BlocProvider.of<ProductBloc>(context);
  }

  @override
  void dispose() {
    productBloc.add(const ResetVariantEvent());
    super.dispose();
  }

  List<String> getAvailableSizes(String color) {
    return widget.product.variants
        .where((variant) => variant.color.codeHexa == color)
        .map((variant) => variant.size.name)
        .toSet()
        .toList();
  }

  List<String> getAvailableColors(String size) {
    return widget.product.variants
        .where((variant) => variant.size.name == size)
        .map((variant) => variant.color.codeHexa)
        .toSet()
        .toList();
  }

  Color getColorFromHex(String colorString) {
    return Color(
        int.parse(colorString.replaceFirst('#', ''), radix: 16) + 0xFF000000);
  }

  void resetSelection() {
    setState(() {
      selectedColor = null;
      selectedSize = null;
    });
    productBloc.add(const ResetVariantEvent());
  }

  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductBloc>(context);
    final uniqueColors = widget.product.variants
        .map((variant) => variant.color.codeHexa)
        .toSet()
        .toList();
    final uniqueSizes = widget.product.variants
        .map((variant) => variant.size.name)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colours.white,
        title: Text(widget.product.name),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          Variant? selectedVariant;
          if (state is ProductError) {
            EasyLoading.showSuccess("Variant non trouvé");
            Future.delayed(const Duration(seconds: 2), () {
              EasyLoading.dismiss();
              Navigator.pop(context);
            });
          }
          if (state is ProductLoaded) {
            selectedVariant = state.selectedVariant;

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Units.edgeInsetsXXLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        items: [
                          Padding(
                            padding:
                                const EdgeInsets.all(Units.edgeInsetsXLarge),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Units.radiusXXXXXLarge),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Units.radiusXXXXXLarge),
                                child: CachedNetworkImage(
                                  imageUrl: widget.product.image,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey.shade100,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(Units.edgeInsetsXXLarge),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Units.radiusXXXXXLarge),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Units.radiusXXXXXLarge),
                                child: CachedNetworkImage(
                                  imageUrl: widget.product.image,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey.shade100,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                        options: CarouselOptions(
                          height: 400,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: _currentIndex,
                          count: 2,
                          effect: const WormEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            activeDotColor: Colors.blueAccent,
                          ),
                        ),
                      ),
                      Text(
                        widget.product.name,
                        style: TextStyles.interBoldH6
                            .copyWith(color: Colours.colorsButtonMenu),
                      ),
                      const SizedBox(
                        height: Units.sizedbox_5,
                      ),
                      Text(
                          '\$${(widget.product.price / 100).toStringAsFixed(2)}',
                          style: TextStyles.interBoldBody1
                              .copyWith(color: Colours.primaryPalette)),
                      const SizedBox(
                        height: Units.sizedbox_5,
                      ),
                      SizedBox(
                        width: Units.sizedbox_220,
                        child: ElevatedButton(
                          style: CustomButtonStyle.customButtonStyle(
                              type: ButtonType.selectedButton,
                              isSelected: isSelected),
                          onPressed: resetSelection,
                          child: const Text(
                            'Réinitialiser la sélection',
                            style: TextStyles.interRegularBody2,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Units.sizedbox_5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Units.edgeInsetsLarge,
                                    vertical: Units.edgeInsetsLarge),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  'taille',
                                  style: TextStyles.interRegularBody1
                                      .copyWith(color: Colours.white),
                                ),
                              ),
                              const SizedBox(height: Units.sizedbox_10),
                              Wrap(
                                children: (selectedColor != null
                                        ? getAvailableSizes(selectedColor!)
                                        : uniqueSizes)
                                    .map((size) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSize = size;
                                        final availableColors =
                                            getAvailableColors(size);
                                        if (selectedColor != null &&
                                            !availableColors
                                                .contains(selectedColor)) {
                                          selectedColor = null;
                                          EasyLoading.showInfo(
                                              "La couleur sélectionnée n'est plus disponible pour cette taille.");
                                        }
                                        if (selectedColor != null) {
                                          productBloc.add(SelectVariantEvent(
                                            productId: widget.product.id,
                                            color: selectedColor!,
                                            size: selectedSize!,
                                          ));
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Units.edgeInsetsXSLarge,
                                          vertical: Units.edgeInsetsXSLarge),
                                      margin: const EdgeInsets.all(
                                          Units.edgeInsetsMedium),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectedSize == size
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            Units.radiusXXLarge),
                                      ),
                                      child: Text(size.substring(0, 1)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Units.edgeInsetsLarge,
                                    vertical: Units.edgeInsetsLarge),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.circular(Units.radiusXLarge),
                                ),
                                child: Text(
                                  'Couleur',
                                  style: TextStyles.interRegularBody1
                                      .copyWith(color: Colours.white),
                                ),
                              ),
                              const SizedBox(height: Units.sizedbox_10),
                              Wrap(
                                children: (selectedSize != null
                                        ? getAvailableColors(selectedSize!)
                                        : uniqueColors)
                                    .map((color) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedColor = color;
                                        final availableSizes =
                                            getAvailableSizes(color);

                                        if (selectedSize != null &&
                                            !availableSizes
                                                .contains(selectedSize)) {
                                          selectedSize = null;
                                          EasyLoading.showInfo(
                                              "La taille sélectionnée n'est plus disponible pour cette couleur.");
                                        }

                                        if (selectedSize != null) {
                                          productBloc.add(SelectVariantEvent(
                                            productId: widget.product.id,
                                            color: selectedColor!,
                                            size: selectedSize!,
                                          ));
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(
                                          Units.edgeInsetsMedium),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: getColorFromHex(color),
                                        border: selectedColor == color
                                            ? Border.all(
                                                color: Colors.black, width: 2)
                                            : null,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: Units.sizedbox_10),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: Units.edgeInsetsXLarge),
                        padding: const EdgeInsets.all(Units.edgeInsetsXXLarge),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(Units.radiusXXXXLarge),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6.0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: selectedVariant != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.color_lens,
                                          color: Colours.colorsButtonMenu),
                                      const SizedBox(width: Units.sizedbox_8),
                                      Text(
                                        'Couleur sélectionnée : ${selectedVariant.color.name}',
                                        style: TextStyles.interRegularBody1,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Units.sizedbox_10),
                                  Row(
                                    children: [
                                      const Icon(Icons.format_size,
                                          color: Colours.colorsButtonMenu),
                                      const SizedBox(width: Units.sizedbox_8),
                                      Text(
                                        'Taille sélectionnée : ${selectedVariant.size.name}',
                                        style: TextStyles.interRegularBody1,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Units.sizedbox_10),
                                  Row(
                                    children: [
                                      const Icon(Icons.inventory,
                                          color: Colours.colorsButtonMenu),
                                      const SizedBox(width: Units.sizedbox_8),
                                      Text(
                                        'Quantité en stock : ${selectedVariant.stockQuantity}',
                                        style: TextStyles.interRegularBody1,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const Center(
                                child: Text(
                                  'Aucun variant sélectionné',
                                  style: TextStyles.interRegularBody1,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          bool isSelected = false;
          Variant? selectedVariant =
              state is ProductLoaded ? state.selectedVariant : null;

          return Container(
            margin: const EdgeInsets.all(Units.edgeInsetsXXLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(Units.radiusXXXXXLarge),
            ),
            height: 80 + MediaQuery.of(context).padding.bottom,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 10,
              top: 10,
              left: 20,
              right: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Total",
                        style: TextStyles.interRegularBody1
                            .copyWith(color: Colours.white)),
                    Text(
                      '\$${(widget.product.price / 100).toStringAsFixed(2)}',
                      style:
                          TextStyles.interBoldH6.copyWith(color: Colours.white),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: CustomButtonStyle.customButtonStyle(
                        type: ButtonType.selectedButton,
                        isSelected: isSelected),
                    onPressed: selectedVariant != null
                        ? () {
                            context.read<CartBloc>().add(AddProduct(
                                cartItem: CartItem(
                                    product: widget.product,
                                    variant: selectedVariant!)));

                            context
                                .read<ProductBloc>()
                                .add(const ResetVariantEvent());
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text(
                      'Ajouter au panier',
                      style: TextStyles.interMediumBody2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

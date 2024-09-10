import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/domain/entities/product/variant.dart';
import 'package:eshop/presentation/blocs/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../domain/entities/cart/cart_item.dart';
import '../../../../../domain/entities/product/price_tag.dart';
import '../../../../../domain/entities/product/product.dart';
import '../../../core/router/app_router.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/input_form_button.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;

  const ProductDetailsView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentIndex =
      0; // Ajout d'un état pour suivre l'index actuel dans le carrousel

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductBloc>(context);

    // Extraire les couleurs uniques des variantes
    final uniqueColors = widget.product.variants
        .map((variant) => variant.color)
        .toSet()
        .toList(); // Utiliser Set pour garder les couleurs uniques

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          Variant? selectedVariant;

          if (state is ProductLoaded) {
            selectedVariant = state.selectedVariant;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ajout du Carrousel pour afficher plusieurs images du produit
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CarouselSlider(
                      items: [
                        Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey
                                .shade200, // Couleur de fond pour rendre l'effet d'arrondi visible
                            borderRadius: BorderRadius.circular(
                                20.0), // Même arrondi pour le fond
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.product.image, // Première image
                            imageBuilder: (context, imageProvider) => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Assurer l'arrondi pour l'image aussi
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit
                                      .contain, // Utiliser BoxFit.contain pour éviter de couper l'image
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey
                                .shade200, // Couleur de fond pour l'effet arrondi
                            borderRadius: BorderRadius.circular(
                                20.0), // Même arrondi pour le fond
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.product.image, // Deuxième image
                            imageBuilder: (context, imageProvider) => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Assurer l'arrondi pour l'image
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit:
                                      BoxFit.contain, // Utiliser BoxFit.contain
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                      options: CarouselOptions(
                        height: 320,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  // Indicateur de page pour le carrousel
                  Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count:
                          2, // Changer ce nombre en fonction du nombre d'images
                      effect: const WormEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        activeDotColor: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nom du produit
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Prix du produit
                  Text(
                    '\$${(widget.product.price / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Affichage des couleurs uniques
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sélection de la taille (inchangé)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Size:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            children: widget.product.variants.map((variant) {
                              return GestureDetector(
                                onTap: () {
                                  // Envoyer l'événement de sélection de taille
                                  productBloc.add(SelectVariantEvent(
                                    productId:  widget.product.id,
                                    color: selectedVariant?.color.name ??
                                        variant.color.name,
                                    size: variant.size.name,
                                  ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedVariant?.size.name ==
                                              variant.size.name
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child:
                                      Text(variant.size.name.substring(0, 1)),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Color:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            children: uniqueColors.map((color) {
                              return GestureDetector(
                                onTap: () {
                                  // Envoyer l'événement au bloc lors de la sélection de la couleur
                                  productBloc.add(SelectVariantEvent(
                                    productId: widget.product.id,
                                    color: color.name,
                                    size: selectedVariant?.size.name ??
                                        widget.product.variants.first.size.name,
                                  ));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(int.parse(
                                            color.codeHexa
                                                .replaceFirst('#', ''),
                                            radix: 16) +
                                        0xFF000000), // Conversion du code hexadécimal en couleur
                                    border: selectedVariant?.color.name ==
                                            color.name
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

                  const SizedBox(height: 10),

                  // Affichage des informations du variant sélectionné
                  if (selectedVariant != null) ...[
                    Text('Selected Color: ${selectedVariant.color.name}'),
                    Text('Selected Size: ${selectedVariant.size.name}'),
                    Text('Stock Quantity: ${selectedVariant.stockQuantity}'),
                  ] else
                    const Text('No variant selected'),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          Variant? selectedVariant =
              state is ProductLoaded ? state.selectedVariant : null;

          return Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
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
                    const Text(
                      "Total",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      '\$${(widget.product.price / 100).toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: selectedVariant != null
                        ? () {
                            context.read<CartBloc>().add(AddProduct(
                                cartItem: CartItem(
                                    product: widget.product,
                                    variant: selectedVariant!)));
                                    
                            context.read<ProductBloc>().add(const ResetVariantEvent());
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text('Add to Cart'),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

 String removeHtmlTags(String text) {
  return text
      .replaceAll('<blockquote>', '')
      .replaceAll('</blockquote>', '')
      .replaceAll('<div>', '')
      .replaceAll('</div>', '');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).width,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: double.infinity,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: [
                  Builder(
                    builder: (BuildContext context) {
                      return Hero(
                        tag: widget.product.id,
                        child: CachedNetworkImage(
                          imageUrl: widget.product.image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                    Colors.grey.shade50.withOpacity(0.25),
                                    BlendMode.softLight),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      '\$${widget.product.price.toString()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 10,
                          bottom: MediaQuery.of(context).padding.bottom),
                      child: Text(
                        removeHtmlTags(widget.product.description),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
              ),
            ),
         
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.secondary,
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
                  '\$${widget.product.price.toString()}',
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
              child: InputFormButton(
                onClick: () {
                  context.read<CartBloc>().add(
                      AddProduct(cartItem: CartItem(product: widget.product)));
                  Navigator.pop(context);
                },
                titleText: "Add to Cart",
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            SizedBox(
              width: 90,
              child: InputFormButton(
                onClick: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.orderCheckout, arguments: [
                    CartItem(
                      product: widget.product,
                    )
                  ]);
                },
                titleText: "Buy",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

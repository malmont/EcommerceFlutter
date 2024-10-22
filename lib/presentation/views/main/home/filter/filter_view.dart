import 'package:eshop/presentation/blocs/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../design/design.dart';
import '../../../../../domain/usecases/product/get_product_usecase.dart';
import '../../../../blocs/category/category_bloc.dart';
import '../../../../blocs/filter/filter_cubit.dart';
import '../../../../widgets/input_form_button.dart';
import '../../../../widgets/input_range_slider.dart';

class FilterView extends StatelessWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter",
          style: TextStyles.interItalicH6.copyWith(
            color: Colours.colorsButtonMenu,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<FilterCubit>().reset();
            },
            icon: const Icon(Icons.refresh, color: Colours.colorsButtonMenu),
          )
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: Units.edgeInsetsXXXLarge,
              top: Units.edgeInsetsXLarge,
            ),
            child: Text("Categories", style: TextStyles.interBoldBody2),
          ),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryState.categories.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: Units.edgeInsetsXXXLarge,
                  vertical: Units.edgeInsetsXLarge,
                ),
                itemBuilder: (context, index) => Row(
                  children: [
                    Text(
                      categoryState.categories[index].name,
                      style: TextStyles.interBoldBody2,
                    ),
                    const Spacer(),
                    BlocBuilder<FilterCubit, FilterProductParams>(
                      builder: (context, filterState) {
                        return Checkbox(
                          checkColor: Colours.white,
                          activeColor: Colours.colorsButtonMenu,
                          value: filterState.categories
                                  .contains(categoryState.categories[index]) ||
                              filterState.categories.isEmpty,
                          onChanged: (bool? value) {
                            context.read<FilterCubit>().updateCategory(
                                category: categoryState.categories[index]);
                          },
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: Units.edgeInsetsXXXLarge, top: Units.edgeInsetsXLarge),
            child: Text(
              "Price Range",
              style: TextStyles.interBoldBody1.copyWith(
                color: Colours.colorsButtonMenu,
              ),
            ),
          ),
          BlocBuilder<FilterCubit, FilterProductParams>(
            builder: (context, state) {
              return RangeSliderExample(
                initMin: state.minPrice,
                initMax: state.maxPrice,
              );
            },
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Builder(builder: (context) {
            return ElevatedButton(
              style: CustomButtonStyle.customButtonStyle(
                  type: ButtonType.selectedButton, isSelected: isSelected),
              onPressed: () {
                context
                    .read<ProductBloc>()
                    .add(GetProducts(context.read<FilterCubit>().state));
                Navigator.of(context).pop();
              },
              child: const Text('Apply Filter'),
            );
          }),
        ),
      ),
    );
  }
}

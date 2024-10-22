import 'package:eshop/design/units.dart';
import 'package:eshop/presentation/blocs/carrier/carrier_info/carrier_fetch_cubit.dart';
import 'package:eshop/presentation/blocs/home/navbar_cubit.dart';
import 'package:eshop/presentation/blocs/order/order_fetch/order_fetch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../core/constant/images.dart';
import '../../../core/error/failures.dart';
import '../../../core/router/app_router.dart';
import '../../../design/design.dart';
import '../../../domain/usecases/user/sign_in_usecase.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../widgets/input_form_button.dart';
import '../../widgets/input_text_form_field.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is UserLoading) {
          EasyLoading.show(status: 'Loading...');
        } else if (state is UserLogged) {
          context.read<CartBloc>().add(const GetCart());
          context.read<DeliveryInfoFetchCubit>().fetchDeliveryInfo();
          context.read<CarrierFetchCubit>().fetchCarrier();
          context.read<OrderFetchCubit>().getOrders();
          context.read<NavbarCubit>().update(0);
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.home,
            ModalRoute.withName(''),
          );
        } else if (state is UserLoggedFail) {
          if (state.failure is CredentialFailure) {
            EasyLoading.showError("Username/Password Wrong!");
          } else {
            EasyLoading.showError("Error");
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: Units.sizedbox_50,
                  ),
                  SizedBox(
                      height: Units.sizedbox_80,
                      child: Image.asset(
                        kAppLogo,
                        color: Colors.black,
                      )),
                  const SizedBox(
                    height: Units.sizedbox_20,
                  ),
                  const Text(
                    "Please enter your e-mail address and password to sign-in",
                    style: TextStyles.interRegularBody1,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  const SizedBox(
                    height: Units.sizedbox_20,
                  ),
                  InputTextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    hint: 'Email',
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: Units.sizedbox_12,
                  ),
                  InputTextFormField(
                    controller: passwordController,
                    textInputAction: TextInputAction.go,
                    hint: 'Password',
                    isSecureField: true,
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      if (_formKey.currentState!.validate()) {
                        context.read<UserBloc>().add(SignInUser(SignInParams(
                              username: emailController.text,
                              password: passwordController.text,
                            )));
                      }
                    },
                  ),
                  const SizedBox(
                    height: Units.sizedbox_10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, AppRouter.forgotPassword);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyles.interRegularBody1.copyWith(
                          color: Colours.colorsButtonMenu,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: Units.sizedbox_26,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: CustomButtonStyle.customButtonStyle(
                            type: ButtonType.selectedButton,
                            isSelected: isSelected),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<UserBloc>()
                                .add(SignInUser(SignInParams(
                                  username: emailController.text,
                                  password: passwordController.text,
                                )));
                          }
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyles.interRegularBody1
                              .copyWith(color: Colours.colorsButtonMenu),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: CustomButtonStyle.customButtonStyle(
                            type: ButtonType.selectedButton,
                            isSelected: isSelected),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Back',
                          style: TextStyles.interRegularBody1
                              .copyWith(color: Colours.colorsButtonMenu),
                        )),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: Units.u16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account! ',
                            style: TextStyles.interRegularBody2),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouter.signUp);
                          },
                          child: const Text('Register',
                              style: TextStyles.interBoldBody2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

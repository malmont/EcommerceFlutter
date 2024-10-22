import 'package:eshop/core/constant/images.dart';
import 'package:flutter/material.dart';

import '../../../../../design/design.dart';
import '../../../../../domain/entities/user/user.dart';
import '../../../../widgets/input_form_button.dart';
import '../../../../widgets/input_text_form_field.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;
  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    email.text = widget.user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Units.edgeInsetsXXXLarge,
            vertical: Units.edgeInsetsXXXLarge),
        child: ListView(
          children: [
            Hero(
              tag: "C001",
              child: CircleAvatar(
                radius: 75.0,
                backgroundColor: Colors.grey.shade200,
                child: Image.asset(kUserAvatar),
              ),
            ),
            const SizedBox(
              height: Units.sizedbox_150,
            ),
            InputTextFormField(
              controller: firstNameController,
              hint: 'First Name',
            ),
            const SizedBox(
              height: Units.sizedbox_12,
            ),
            InputTextFormField(
              controller: firstNameController,
              hint: 'Last Name',
            ),
            const SizedBox(
              height: Units.sizedbox_12,
            ),
            InputTextFormField(
              controller: email,
              enable: false,
              hint: 'Email Address',
            ),
            const SizedBox(
              height: Units.sizedbox_12,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Units.edgeInsetsXXXLarge,
            vertical: Units.edgeInsetsXLarge),
        child: ElevatedButton(
          style: CustomButtonStyle.customButtonStyle(
              type: ButtonType.selectedButton, isSelected: isSelected),
          onPressed: () {},
          child: const Text('Update'),
        ),
      )),
    );
  }
}

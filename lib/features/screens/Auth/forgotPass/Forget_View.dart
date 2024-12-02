import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class ForgetView extends StatefulWidget {
  const ForgetView({super.key});

  @override
  State<ForgetView> createState() => _ForgetViewState();
}

class _ForgetViewState extends State<ForgetView> {
  TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style:
              theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Forgot password',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Please enter your email to reset the password',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColor.textColorHint, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'your email',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _emailcontroller,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "plz enter your emaail";
                }
                var regexp = RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                if (!regexp.hasMatch(value)) {
                  return 'Invalid email';
                }
                return null;
              },
              cursorColor: AppColor.primaryColor,
              style: theme.textTheme.bodySmall,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                suffix: Icon(
                  Icons.email,
                  color: theme.primaryColor,
                ),
                label: Text(
                  'E-mail',
                  style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 20,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                hintText: 'enter your email ',
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500, color: Colors.black38),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(width: 2, color: theme.primaryColor)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(width: 2, color: theme.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(width: 2, color: theme.primaryColor),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  backgroundColor: AppColor.primaryColor),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reset Password',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 22,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

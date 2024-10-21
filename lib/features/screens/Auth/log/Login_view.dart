import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isObscure = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontrolar = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var formkey = GlobalKey<FormState>();
    var theme = Theme.of(context);
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  delay: const Duration(microseconds: 550),
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    width: media.width,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Login',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.primaryColor),
                    ),
                  ),
                ),
                FadeInDown(
                  delay: const Duration(microseconds: 400),
                  child: Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/Login.png')),
                ),
                FadeInRight(
                  delay: const Duration(microseconds: 550),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Text(
                      textAlign: TextAlign.start,
                      'welcome back!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: emailcontroller,
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
                    cursorColor: ColorPallets.redbutton,
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
                        borderSide:
                            BorderSide(width: 2, color: theme.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(width: 2, color: theme.primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: isObscure,
                  controller: passwordcontrolar,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Plz enter your password';
                    }
                    return null;
                  },
                  cursorColor: ColorPallets.redbutton,
                  style: theme.textTheme.bodySmall,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          color: theme.primaryColor,
                        )),
                    label: Text(
                      'password',
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 20,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    hintText: 'enter your password ',
                    hintStyle: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black38),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(width: 2, color: theme.primaryColor)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(width: 2, color: theme.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(width: 2, color: theme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 250),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        backgroundColor: ColorPallets.redbutton),
                    onPressed: () {
                      // if (formkey.currentState!.validate()) {
                      //   print('valid email');
                      // }
                      Navigator.pushNamed(context, PageRoutesName.layout);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Login',
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
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 450),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t you have an account?',
                        style: theme.textTheme.bodySmall,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, PageRoutesName.signup);
                          },
                          child: Text(
                            'SignUp',
                            style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorPallets.redbutton),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/Auth/service/api_Manager_Auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? users;
  bool isObscure = true;
  // bool isLoading = false;
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontrolar = TextEditingController();

  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  width: media.width,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Login',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.primaryColor),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/Login.png')),
                const SizedBox(
                  height: 45,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: Text(
                    textAlign: TextAlign.start,
                    'welcome back!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColor.textColorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                  height: 20,
                ),
                TextFormField(
                  obscureText: isObscure,
                  controller: _passwordcontrolar,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Plz enter your password';
                    }
                    return null;
                  },
                  cursorColor: AppColor.primaryColor,
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
                  height: 10,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Row(
                //       children: [
                //         Radio(
                //           activeColor: theme.primaryColor,
                //           value: 'user',
                //           groupValue: users,
                //           onChanged: (val) {
                //             setState(() {
                //               users = val;
                //             });
                //           },
                //         ),
                //         Text(
                //           'User',
                //           style: theme.textTheme.bodyMedium
                //               ?.copyWith(color: theme.primaryColor),
                //         ),
                //       ],
                //     ),
                //     Row(
                //       children: [
                //         Radio(
                //             activeColor: theme.primaryColor,
                //             value: 'admin',
                //             groupValue: users,
                //             onChanged: (val) {
                //               setState(() {
                //                 users = val;
                //               });
                //             }),
                //         Text(
                //           'Admin',
                //           style: theme.textTheme.bodyMedium
                //               ?.copyWith(color: theme.primaryColor),
                //         ),
                //       ],
                //     )
                //   ],
                // ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PageRoutesName.forgetPass);
                  },
                  child: Text(
                    'forgot password?',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.primaryColor),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      backgroundColor: AppColor.primaryColor),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      _Login();
                    }

                    // if (users == 'admin') {
                    //   Navigator.pushNamed(context, PageRoutesName.admin);
                    // } else {
                    //   Navigator.pushNamed(context, PageRoutesName.layout);
                    // }
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
                Row(
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
                              color: AppColor.primaryColor),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void _Login() async {
    final email = _emailcontroller.text.trim();
    final password = _passwordcontrolar.text.trim();

    try {
      final response = await ApiManagerAuth().login(email, password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
              'Login Successful! 🎉',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColor.accentGold),
            ),
            backgroundColor: AppColor.accentGreen,
            duration: Duration(milliseconds: 300)),
      );
      if (response.token != null) {
        await Future.delayed(const Duration(milliseconds: 700));
        Navigator.pushNamed(context, PageRoutesName.layout);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              'Error: $e',
              style: const TextStyle(
                color: AppColor.errorColor,
              ),
            )),
      );
    }
  }
}

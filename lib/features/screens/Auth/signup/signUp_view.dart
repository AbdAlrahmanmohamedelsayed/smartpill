import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/Auth/service/api_Manager_Auth.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  String? users;
  bool isObscure = true;
  TextEditingController _usernamecontrolar = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontrolar = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var formkey = GlobalKey<FormState>();
    var theme = Theme.of(context);
    // var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style:
              theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  delay: const Duration(microseconds: 400),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      width: 450,
                      child: Image.asset(
                        'assets/images/Sign_up.png',
                        fit: BoxFit.cover,
                      )),
                ),
                TextFormField(
                  controller: _usernamecontrolar,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "plz enter your full name";
                    }

                    return null;
                  },
                  cursorColor: AppColor.primaryColor,
                  style: theme.textTheme.bodySmall,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    suffix: Icon(
                      Icons.person,
                      color: theme.primaryColor,
                    ),
                    label: Text(
                      'username',
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 20,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    hintText: 'enter your full name ',
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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: theme.primaryColor,
                          value: 'user',
                          groupValue: users,
                          onChanged: (val) {
                            setState(() {
                              users = val;
                            });
                          },
                        ),
                        Text(
                          'User',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.primaryColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            activeColor: theme.primaryColor,
                            value: 'doctor',
                            groupValue: users,
                            onChanged: (val) {
                              setState(() {
                                users = val;
                              });
                            }),
                        Text(
                          'Doctor',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.primaryColor),
                        ),
                      ],
                    )
                  ],
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      backgroundColor: AppColor.buttonPrimary),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      _Signup();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create Account',
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
        ),
      ),
    );
  }

  void _Signup() async {
    final username = _usernamecontrolar.text.trim();
    final email = _emailcontroller.text.trim();
    final password = _passwordcontrolar.text.trim();
    final role = users;
    try {
      final response =
          await ApiManagerAuth().SignUp(username, email, password, role!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Sign-up successful!",
            style: TextStyle(
                fontSize: 22,
                color: AppColor.accentGreen,
                fontWeight: FontWeight.w600),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

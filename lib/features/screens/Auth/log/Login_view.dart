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
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontrolar = TextEditingController();

  var formkey = GlobalKey<FormState>();

  // Extracted method to create a consistent text field style

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
                    child: Image.asset(
                        width: media.width * 0.6, 'assets/images/Login.png')),
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
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, PageRoutesName.layout);
                    },
                    child: Text('......')),
                const SizedBox(
                  height: 20,
                ),
                // Email TextField
                TextFormField(
                  controller: _emailcontroller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    var regexp = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                    if (!regexp.hasMatch(value)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  cursorColor: AppColor.primaryColor,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                  decoration: _buildInputDecoration(
                    context: context,
                    labelText: 'E-mail',
                    hintText: 'Enter your email',
                    suffixIcon: Icons.email,
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  obscureText: isObscure,
                  controller: _passwordcontrolar,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your password';
                    }
                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}$')
                        .hasMatch(value)) {
                      return 'Password must include an uppercase letter, a lowercase letter, a special character, and be at least 8 characters long.';
                    }
                    return null;
                  },
                  cursorColor: AppColor.primaryColor,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                  decoration: _buildInputDecoration(
                    context: context,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    suffixIcon: Icons.lock,
                    isPassword: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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

  // Login Method
  void _Login() async {
    final email = _emailcontroller.text.trim();
    final password = _passwordcontrolar.text.trim();

    try {
      final response = await ApiManagerAuth().login(email, password);

      if (response.token != null) {
        final userRole = response.role;

        _showSuccessDialog(context, userRole);
      } else {
        _showFailureDialog(
            context, 'Unable to authenticate. Please try again.');
      }
    } catch (e) {
      _showFailureDialog(context, 'Invalid email or password ');
    }
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String labelText,
    required String hintText,
    required IconData suffixIcon,
    bool isPassword = false,
  }) {
    var theme = Theme.of(context);
    return InputDecoration(
      contentPadding: const EdgeInsets.all(16),
      suffixIcon: isPassword
          ? IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              icon: Icon(
                isPassword && isObscure
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: theme.primaryColor,
              ),
            )
          : Icon(
              suffixIcon,
              color: theme.primaryColor,
            ),
      label: Text(
        labelText,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 20,
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      hintText: hintText,
      hintStyle: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.black38,
      ),
      border: _buildOutlineBorder(theme),
      enabledBorder: _buildOutlineBorder(theme),
      focusedBorder: _buildOutlineBorder(theme),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2, color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2, color: Colors.red),
      ),
    );
  }

  OutlineInputBorder _buildOutlineBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(width: 2, color: theme.primaryColor),
    );
  }

  // Success Dialog Function
  void _showSuccessDialog(BuildContext context, String? userRole) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Automatically navigate based on role after 1 second
        Future.delayed(Duration(seconds: 1), () {
          if (userRole == "user") {
            Navigator.pushReplacementNamed(context, PageRoutesName.layout);
          } else if (userRole == "admin") {
            // Navigate to admin layout
            Navigator.pushReplacementNamed(context, PageRoutesName.admin);
          } else {
            // Default navigation if role is null or unrecognized
            Navigator.pushReplacementNamed(context, PageRoutesName.layout);
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColor.accentGreen,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'Login Successful!',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome back to SmartPill',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFailureDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColor.errorColor,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'Login Failed',
                  style: TextStyle(
                    color: AppColor.errorColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

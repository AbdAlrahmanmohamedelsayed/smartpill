import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/Auth/service/api_Manager_Auth.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  String? userType = 'user'; // Set default value to 'user'
  bool isUserSelected = true;
  bool isCareGiverSelected = false;
  bool isObscure = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var madi = MediaQuery.of(context);
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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  delay: const Duration(microseconds: 400),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      width: madi.size.width * .8,
                      child: Image.asset(
                        'assets/images/Sign_up.png',
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  style: theme.textTheme.bodySmall,
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your full name";
                    }
                    if (value.length < 3) {
                      return "Username must be at least 3 characters";
                    }
                    return null;
                  },
                  cursorColor: AppColor.primaryColor,
                  decoration: _inputDecoration(theme, 'Username', Icons.person,
                      false, 'Enter your full name'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: theme.textTheme.bodySmall,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    final emailPattern = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailPattern.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  cursorColor: AppColor.primaryColor,
                  decoration: _inputDecoration(theme, 'E-mail', Icons.email,
                      false, 'Enter your email address'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: theme.textTheme.bodySmall,
                  obscureText: isObscure,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your password';
                    }
                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}$')
                        .hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter, one lowercase letter, one special character, and be at least 8 characters long';
                    }
                    return null;
                  },
                  cursorColor: AppColor.primaryColor,
                  decoration: _inputDecoration(theme, 'Password', Icons.lock,
                      true, 'Enter your secure password'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCheckbox('User', theme),
                    _buildCheckbox('Care Giver', theme),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      backgroundColor: AppColor.buttonPrimary,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          userType != null) {
                        _signup();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please complete all fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
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
                        const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 22)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, ThemeData theme) {
    bool isSelected = title == 'User' ? isUserSelected : isCareGiverSelected;

    return Row(
      children: [
        Checkbox(
          activeColor: theme.primaryColor,
          value: isSelected,
          onChanged: (val) {
            setState(() {
              if (title == 'User') {
                isUserSelected = val ?? false;
                if (isUserSelected) {
                  isCareGiverSelected = false;
                  userType = 'user';
                } else if (!isCareGiverSelected) {
                  // Ensure at least one option is selected
                  isUserSelected = true;
                  userType = 'user';
                }
              } else {
                // Care Giver
                isCareGiverSelected = val ?? false;
                if (isCareGiverSelected) {
                  isUserSelected = false;
                  userType = 'caregiver';
                } else if (!isUserSelected) {
                  // Ensure at least one option is selected
                  isCareGiverSelected = true;
                  userType = 'caregiver';
                }
              }
            });
          },
        ),
        Text(
          title,
          style:
              theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String label, IconData icon,
      bool isPassword, String hintText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(12),
      suffixIcon: isPassword
          ? IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              icon: Icon(
                isObscure ? Icons.visibility : Icons.visibility_off,
                color: theme.primaryColor,
              ),
            )
          : Icon(icon, color: theme.primaryColor),
      labelText: label,
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: AppColor.textColorPrimary,
      ),
      hintText: hintText,
      hintStyle: theme.textTheme.bodySmall?.copyWith(
        color: AppColor.textColorHint,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          width: 1,
          color: theme.primaryColor,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          width: 1,
          color: theme.primaryColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor, width: 2),
      ),
    );
  }

  void _signup() async {
    try {
      final response = await ApiManagerAuth().signUp(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        userType!,
      );

      if (response.token != null) {
        // Show success dialog
        _showSignupSuccessDialog(context, userType);
      } else {
        _showSignupFailureDialog(context, "Sign Up failed");
      }
    } catch (e) {
      _showSignupFailureDialog(context, "Failed to Sign Up: ${e.toString()}");
    }
  }

  void _showSignupSuccessDialog(BuildContext context, String? userType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          if (userType == "user") {
            Navigator.pushNamedAndRemoveUntil(
                context, PageRoutesName.layout, (route) => false);
          } else if (userType == "admin") {
            Navigator.pushNamedAndRemoveUntil(
                context, PageRoutesName.admin, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, PageRoutesName.layout, (route) => false);
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
                  'Registration Successful!',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome to SmartPill',
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

  void _showSignupFailureDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  Icons.error,
                  color: AppColor.errorColor,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'Registration Failed',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Failed to register. Please try again later.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

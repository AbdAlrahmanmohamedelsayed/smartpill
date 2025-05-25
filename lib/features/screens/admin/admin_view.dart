import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);

    // Controller for the TextField
    final TextEditingController caregiverController = TextEditingController();
    // State for error message
    ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

    // Validation function
    void validateInput(String value) {
      if (value.length > 11) {
        errorMessage.value = 'Number must not exceed 11 digits';
      } else if (!value.startsWith('011') &&
          !value.startsWith('012') &&
          !value.startsWith('015') &&
          !value.startsWith('010')) {
        errorMessage.value = 'Number must start with 011, 012, 015, or 010';
      } else {
        errorMessage.value = null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              PageRoutesName.login,
              (route) => false,
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 30,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          'CareGiver Dashboard',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColor.whiteColor,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        toolbarHeight: 80,
      ),
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            height: media.size.height * 0.4,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Caregiver Management',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColor.textColorPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColor.accentGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ValueListenableBuilder<String?>(
                        valueListenable: errorMessage,
                        builder: (context, error, _) {
                          return TextField(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColor.textColorPrimary,
                            ),
                            controller: caregiverController,
                            keyboardType: TextInputType.number,
                            onChanged: validateInput,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.group,
                                color: AppColor.primaryColor,
                                size: 28,
                              ),
                              hintText: 'Number of Caregivers',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColor.textColorSecondary,
                              ),
                              filled: true,
                              fillColor: AppColor.backgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor.errorColor,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor.errorColor,
                                  width: 2,
                                ),
                              ),
                              errorText: error,
                              errorStyle: TextStyle(
                                color: AppColor.errorColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              errorMaxLines: 2,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Status: Available',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColor.successColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.accentGreen,
                        foregroundColor: AppColor.whiteColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      onPressed: () {
                        if (errorMessage.value == null) {
                          print('Valid input: ${caregiverController.text}');
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.send,
                            size: 22,
                            color: AppColor.whiteColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Send',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColor.whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/chatTips/Gemini/SymptomTips_gemini.dart';
import 'package:smartpill/features/screens/menu/chatTips/Gemini/api_service_gemini.dart';
import 'package:smartpill/features/screens/menu/chatTips/widgets/InputField_Chat.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatGemini extends StatefulWidget {
  const ChatGemini({super.key});

  @override
  State createState() => _ChatGeminiState();
}

class _ChatGeminiState extends State<ChatGemini> {
  final TextEditingController _controller = TextEditingController();
  final ApiServiceGemini _apiService = ApiServiceGemini();
  bool _isLoading = false;
  List<SymptomTipGmini>? _symptomTips;
  String? _errorMessage;
  String _lastQuery = '';

  Future _getTips(String text) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _lastQuery = text;
    });

    try {
      final tipsResponse = await _apiService.getTips(text);
      setState(() {
        _symptomTips = tipsResponse.tips;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get tips: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      );
    } else if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    } else if (_symptomTips != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Search: $_lastQuery',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColor.primaryColor),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 4,
              color: AppColor.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tips for your symptoms:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 8),
                    for (int i = 0; i < _symptomTips!.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColor.accentGreen,
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    _symptomTips![i].tip,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.textColorPrimary),
                                    speed: const Duration(milliseconds: 30),
                                    cursor: '-',
                                  ),
                                ],
                                totalRepeatCount: 1,
                                isRepeatingAnimation: false,
                                displayFullTextOnTap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              cursor: '-',
              'Enter your symptoms to get helpful tips With Ai ',
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColor.primaryColor, fontWeight: FontWeight.w600),
              speed: const Duration(milliseconds: 80),
            ),
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))),
        backgroundColor: AppColor.primaryColor,
        toolbarHeight: 80,
        titleTextStyle: theme.appBarTheme.titleTextStyle
            ?.copyWith(color: AppColor.whiteColor),
        title: Text(
          'Tips Plus',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: _buildMainContent(),
            ),
            InputFieldChat(
              controller: _controller,
              onSend: (p0) {
                if (_controller.text.isNotEmpty) {
                  _getTips(_controller.text);
                  _controller.clear();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

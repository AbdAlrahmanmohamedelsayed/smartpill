// chat_view.dart
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/chatTips/Gemini/SymptomTips_gemini.dart';
import 'package:smartpill/features/screens/menu/chatTips/Gemini/api_service_gemini.dart';
import 'package:smartpill/features/screens/menu/chatTips/Gemini/tips_card_gemini.dart';

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

  Future _getTips(String text) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
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
      ));
    } else if (_errorMessage != null) {
      return Center(
          child:
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)));
    } else if (_symptomTips != null) {
      return ListView.builder(
        itemCount: _symptomTips!.length,
        itemBuilder: (context, index) {
          return TipsCardGem(tip: _symptomTips![index].tip);
        },
      );
    } else {
      // Initial state with animated text
      return Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Enter your symptoms to get helpful tips',
              textStyle: Theme.of(context).textTheme.bodyLarge,
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
        title: const Text('Tips'),
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

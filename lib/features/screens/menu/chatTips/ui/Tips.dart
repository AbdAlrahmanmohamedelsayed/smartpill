// chat_view.dart
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/chatTips/service/ApiService_chat.dart';
import 'package:smartpill/features/screens/menu/chatTips/widgets/InputField_Chat.dart';
import 'package:smartpill/features/screens/menu/chatTips/widgets/tips_card.dart';
import 'package:smartpill/model/SymptomTips.dart';

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _ChatViewState();
}

class _ChatViewState extends State<Tips> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<SymptomTip>? _symptomTips;
  String? _errorMessage;

  Future<void> _getTips(String text) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tipsResponse = await _apiService.getTips(text);
      setState(() {
        _symptomTips = tipsResponse.symptoms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get tips: ${e.toString()}';
        _isLoading = false;
      });
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
        title: const Text(' Tips'),
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

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: AppColor.primaryColor,
      ));
    } else if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    } else if (_symptomTips == null || _symptomTips!.isEmpty) {
      return Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              cursor: '-',
              'Enter your symptoms to get helpful tips Ai ',
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColor.primaryColor, fontWeight: FontWeight.w600),
              speed: const Duration(milliseconds: 80),
            ),
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _symptomTips!.length,
        itemBuilder: (context, index) {
          return TipCard(symptomTip: _symptomTips![index]);
        },
      );
    }
  }
}

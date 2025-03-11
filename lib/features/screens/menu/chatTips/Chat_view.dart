// chat_view.dart
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/chatTips/ApiService_chat.dart';
import 'package:smartpill/features/screens/widgets/tips_card.dart';
import 'package:smartpill/model/SymptomTips.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
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
        title: const Text('Chat Tips'),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMainContent(),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (_symptomTips == null || _symptomTips!.isEmpty) {
      return const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                "Please enter below your symptoms or how you are feeling",
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColor.primaryColor),
              ),
            )
          ],
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

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 20),
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: AppColor.textColorHint,
                  fontSize: 18,
                ),
                hintText: "How Are You Feeling At The Moment",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColor.primaryColor,
                        width: 2.0,
                        style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColor.primaryColor,
                        width: 2.0,
                        style: BorderStyle.solid)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                        style: BorderStyle.solid)),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              size: 32,
            ),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _getTips(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class BuildDrugInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Future<List<String>> Function(String) onSearch;

  const BuildDrugInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSearch,
  });

  @override
  State<BuildDrugInputField> createState() => _BuildDrugInputFieldState();
}

class _BuildDrugInputFieldState extends State<BuildDrugInputField> {
  List<String> suggestions = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a drug name';
            }
            return null;
          },
          style: Theme.of(context).textTheme.bodySmall,
          controller: widget.controller,
          cursorColor: Theme.of(context).primaryColor,
          onChanged: handleSearch,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: isSearching
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
                  )
                : const Icon(
                    Icons.search,
                    color: AppColor.primaryColor,
                    size: 22,
                  ),
            hintText: widget.hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColor.textColorHint),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        if (suggestions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  widget.controller.text = suggestion;
                  setState(() {
                    suggestions = [];
                  });
                },
              );
            },
          ),
      ],
    );
  }

  void handleSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        suggestions = [];
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      final results = await widget.onSearch(query);
      setState(() {
        suggestions = results.isNotEmpty
            ? results
            : []; // Ensure empty list if no results
      });
    } catch (e) {
      print('Error fetching suggestions: $e');
      setState(() {
        suggestions = [];
      });
    } finally {
      setState(() {
        isSearching = false;
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/Drug%20Alternatives/services/Api_drug_alternatives.dart';
import 'package:smartpill/features/screens/menu/Drug%20Alternatives/widgets/AlternativeCard.dart';
import 'package:smartpill/model/DrugAlternative.dart';

class DrugAlternatives extends StatefulWidget {
  const DrugAlternatives({super.key});

  @override
  State<DrugAlternatives> createState() => _DrugAlternativesState();
}

class _DrugAlternativesState extends State<DrugAlternatives> {
  final TextEditingController _drugNameController = TextEditingController();
  final ApiServiceDrugAlternatives _apiService = ApiServiceDrugAlternatives();

  List<DrugAlternative> _suggestions = [];
  List<DrugAlternative>? _alternatives;
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _drugNameController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _drugNameController.removeListener(_onSearchTextChanged);
    _drugNameController.dispose();
    super.dispose();
  }

  // Method to handle text field changes and fetch suggestions
  Future<void> _onSearchTextChanged() async {
    final query = _drugNameController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    if (query.length < 2) return; // Don't search for very short queries

    setState(() {
      _isSearching = true;
      _showSuggestions = true;
    });

    try {
      final suggestions = await _apiService.getDrugSuggestions(query);

      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isSearching = false;

          // Show error message if no suggestions found
          if (suggestions.isEmpty) {
            _errorMessage = 'No suggestions available';
            _showSuggestions = false;
          } else {
            _errorMessage = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isSearching = false;
          _errorMessage = 'No suggestions available';
          _showSuggestions = false;
        });
      }
    }
  }

  // Method to search for drug alternatives
  Future<void> _searchDrugAlternatives(String drugName) async {
    final trimmedDrugName = drugName.trim();

    if (trimmedDrugName.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a drug name';
      });
      return;
    }

    // Hide suggestions
    setState(() {
      _showSuggestions = false;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final alternatives =
          await _apiService.getDrugAlternatives(trimmedDrugName);

      if (mounted) {
        setState(() {
          _alternatives = alternatives;
          _isLoading = false;

          // Show error message if no alternatives found
          if (alternatives.isEmpty) {
            _errorMessage = 'No data available';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No data available';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: Text(
          'Drug Alternatives',
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: AppColor.whiteColor, fontSize: 25),
        ),
        leading: BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Column(
        children: [
          // Search Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            width: media.size.width,
            height: media.size.height * .10,
            child: TextField(
              controller: _drugNameController,
              decoration: InputDecoration(
                  hintText: 'Enter your drug Name',
                  hintStyle: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColor.textColorHint),
                  suffixIcon: _isSearching
                      ? Container(
                          width: 32,
                          height: 32,
                          padding: const EdgeInsets.all(8),
                          child: const CircularProgressIndicator(
                            color: AppColor.primaryColor,
                            strokeWidth: 2,
                          ),
                        )
                      : IconButton(
                          onPressed: () =>
                              _searchDrugAlternatives(_drugNameController.text),
                          icon: const Icon(
                            Icons.search,
                            size: 32,
                          ),
                          color: AppColor.primaryColor),
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColor.primaryColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColor.primaryColor, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(22)),
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 16),
              cursorColor: AppColor.primaryColor,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => _searchDrugAlternatives(value),
            ),
          ),

          // Suggestions List
          if (_showSuggestions && _suggestions.isNotEmpty)
            Container(
              constraints: BoxConstraints(
                maxHeight: media.size.height * 0.3,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(
                      suggestion.name,
                      style: theme.textTheme.bodyMedium,
                    ),
                    onTap: () {
                      setState(() {
                        _drugNameController.text = suggestion.name;
                        _showSuggestions = false;
                      });
                      _searchDrugAlternatives(suggestion.name);
                    },
                    leading: const Icon(
                      Icons.medication,
                      color: AppColor.primaryColor,
                    ),
                  );
                },
              ),
            ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              ),
            ),

          // Results list
          if (!_isLoading &&
              !_showSuggestions &&
              _alternatives != null &&
              _alternatives!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _alternatives!.length,
                itemBuilder: (context, index) {
                  final alternative = _alternatives![index];
                  return AlternativeCard(
                    alternative: alternative,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

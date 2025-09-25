import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_app_assigment/model/quote_model/Quote_Model.dart';
import 'package:shoe_app_assigment/service/quote_api_service.dart';

// Quote state for managing loading, success, and error states
class QuoteState {
  final QuoteModel? quote;
  final bool isLoading;
  final String? error;
  final bool hasConnection;

  QuoteState({
    this.quote,
    this.isLoading = false,
    this.error,
    this.hasConnection = true,
  });

  QuoteState copyWith({
    QuoteModel? quote,
    bool? isLoading,
    String? error,
    bool? hasConnection,
  }) {
    return QuoteState(
      quote: quote ?? this.quote,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }
}

// Quote StateNotifier
class QuoteNotifier extends StateNotifier<QuoteState> {
  QuoteNotifier() : super(QuoteState()) {
    // Load initial quote when provider is created
    loadRandomQuote();
  }

  // Load random quote
  Future<void> loadRandomQuote() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Check connection first
      final hasConnection = await ApiService.hasConnection();
      
      if (!hasConnection) {
        state = state.copyWith(
          isLoading: false,
          hasConnection: false,
          error: 'No internet connection',
        );
        return;
      }

      // Fetch quote
      final quote = await ApiService.getRandomQuote();
      state = state.copyWith(
        quote: quote,
        isLoading: false,
        hasConnection: true,
        error: null,
      );
      
      print('✅ Quote loaded successfully');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('❌ Quote loading failed: $e');
    }
  }

  // Refresh quote manually
  Future<void> refreshQuote() async {
    await loadRandomQuote();
  }

  // Load motivational quotes specifically
  Future<void> loadMotivationalQuote() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final quote = await ApiService.getQuoteByTags(['motivational', 'inspirational', 'success']);
      state = state.copyWith(
        quote: quote,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Quote provider
final quoteProvider = StateNotifierProvider<QuoteNotifier, QuoteState>((ref) {
  return QuoteNotifier();
});
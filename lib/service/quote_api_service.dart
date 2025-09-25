import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoe_app_assigment/model/quote_model/Quote_Model.dart';

class ApiService {
  static const String _baseUrl = 'https://zenquotes.io/api';
  static const String _randomQuoteEndpoint = '/random';

  // Get random inspirational quote
  static Future<QuoteModel> getRandomQuote() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_randomQuoteEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - Please check your connection');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final quote = QuoteModel.fromJson(data);
        
        print('🎯 Quote fetched successfully: "${quote.content}" - ${quote.author}');
        return quote;
      } else {
        throw Exception('Failed to load quote. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error: $e');
      // Return fallback quote if API fails
      return _getFallbackQuote();
    }
  }

  // Get quote with specific tags (optional enhancement)
  static Future<QuoteModel> getQuoteByTags(List<String> tags) async {
    try {
      final tagsQuery = tags.join('|');
      final response = await http.get(
        Uri.parse('$_baseUrl$_randomQuoteEndpoint?tags=$tagsQuery'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return QuoteModel.fromJson(data);
      } else {
        throw Exception('Failed to load quote with tags');
      }
    } catch (e) {
      print('❌ Tagged Quote Error: $e');
      return _getFallbackQuote();
    }
  }

  // Fallback quote when API fails
  static QuoteModel _getFallbackQuote() {
    final fallbackQuotes = [
      {
        'content': 'The best time to plant a tree was 20 years ago. The second best time is now.',
        'author': 'Chinese Proverb',
        'tags': ['inspirational', 'wisdom'],
        'length': 77
      },
      {
        'content': 'Your only limit is your mind.',
        'author': 'Unknown',
        'tags': ['motivational', 'success'],
        'length': 26
      },
      {
        'content': 'Great things never come from comfort zones.',
        'author': 'Unknown',
        'tags': ['motivational', 'success'],
        'length': 40
      },
      {
        'content': 'Dream it. Wish it. Do it.',
        'author': 'Unknown',
        'tags': ['inspirational', 'dreams'],
        'length': 24
      },
    ];

    final randomIndex = DateTime.now().millisecond % fallbackQuotes.length;
    return QuoteModel.fromJson(fallbackQuotes[randomIndex]);
  }

  // Check internet connectivity
  static Future<bool> hasConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_randomQuoteEndpoint'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
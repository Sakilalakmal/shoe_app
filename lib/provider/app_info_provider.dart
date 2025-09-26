import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_app_assigment/model/app_about_info/about_us_info.dart';

class AppInfoState {
  final AppInfoModel? appInfo;
  final bool isLoading;
  final String? error;
  
  AppInfoState({
    this.appInfo, 
    this.isLoading = false, 
    this.error,
  });

  AppInfoState copyWith({
    AppInfoModel? appInfo,
    bool? isLoading,
    String? error,
  }) {
    return AppInfoState(
      appInfo: appInfo ?? this.appInfo,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AppInfoNotifier extends StateNotifier<AppInfoState> {
  AppInfoNotifier() : super(AppInfoState(isLoading: true)) {
    loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      print('🔄 Loading app info from JSON...');
      
      // ✅ CORRECTED PATH - matches your actual file location
      final jsonString = await rootBundle.loadString('assets/json/app_info.json');
      
      final jsonMap = jsonDecode(jsonString);
      final info = AppInfoModel.fromJson(jsonMap);
      
      state = AppInfoState(appInfo: info, isLoading: false);
      
      print('✅ App info loaded successfully');
      print('📱 App: ${info.appInfo.appName} v${info.appInfo.version}');
      
    } catch (e) {
      state = AppInfoState(isLoading: false, error: e.toString());
      print('❌ App info load failed: $e');
      print('🔍 Make sure assets/json/app_info.json exists and is declared in pubspec.yaml');
    }
  }

  void refreshAppInfo() {
    loadAppInfo();
  }
}

final appInfoProvider = StateNotifierProvider<AppInfoNotifier, AppInfoState>(
  (ref) => AppInfoNotifier(),
);
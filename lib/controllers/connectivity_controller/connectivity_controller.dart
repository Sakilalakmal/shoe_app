import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/about_app_screen.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  
  // Observable connectivity status
  var isConnected = true.obs;
  var isOfflineScreenShown = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _startListening();
  }
  
  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
  
  // Initialize connectivity check
  Future<void> _initConnectivity() async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print('Error checking connectivity: $e');
    }
  }
  
  // Start listening to connectivity changes
  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (error) {
        print('Connectivity error: $error');
      },
    );
  }
  
  // Update connection status and handle navigation
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool wasConnected = isConnected.value;
    
    // Check if any of the connectivity results indicate connection
    bool hasConnection = results.any((result) => 
      result != ConnectivityResult.none
    );
    
    isConnected.value = hasConnection;
    
    // Handle offline scenario - show About Us screen
    if (!hasConnection && wasConnected && !isOfflineScreenShown.value) {
      _showOfflineScreen();
    }
    
    // Handle back online scenario - return to previous screen
    if (hasConnection && !wasConnected && isOfflineScreenShown.value) {
      _hideOfflineScreen();
    }
  }
  
  // Show offline screen (About Us screen)
  void _showOfflineScreen() {
    isOfflineScreenShown.value = true;
    Get.to(
      () => const AboutAppScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
      routeName: '/about-app-offline',
    );
  }
  
  // Hide offline screen and return to previous screen
  void _hideOfflineScreen() {
    isOfflineScreenShown.value = false;
    // Check if current route is the offline About Us screen
    if (Get.currentRoute == '/about-app-offline') {
      Get.back();
    }
  }
  
  // Manual connectivity check
  Future<bool> checkConnectivity() async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      bool hasConnection = result.any((result) => 
        result != ConnectivityResult.none
      );
      isConnected.value = hasConnection;
      return hasConnection;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }
}
import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/services/notification_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _localStorageService = locator<LocalStorageService>();
  final _notificationService = locator<NotificationService>();
  final _authService = locator<AuthService>();
  final _dialogService = locator<DialogService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // Start setup immediately (non-blocking)
    final setupFuture = _initialSetup();
    
    // Ensure minimum splash screen display time (better UX)
    final minDisplayTime = Future.delayed(const Duration(milliseconds: 800));
    
    // Wait for both setup and minimum display time
    try {
      await Future.wait<void>([
        setupFuture.timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            print("⚠️ Startup timeout - forcing navigation");
            _forceNavigation();
          },
        ),
        minDisplayTime,
      ]);
    } catch (e) {
      print("❌ Startup logic error: $e");
      // Ensure minimum display time even on error
      await minDisplayTime;
      _forceNavigation();
    }
  }
  
  // Force navigation as last resort
  void _forceNavigation() {
    try {
      bool onBoarding = false;
      bool isLogin = false;
      
      try {
        onBoarding = _localStorageService.onBoarding;
      } catch (_) {}
      
      try {
        isLogin = _authService.isLogin;
      } catch (_) {}
      
      if (onBoarding) {
        if (isLogin) {
          _navigationService.replaceWithRootView();
        } else {
          _navigationService.replaceWithLoginView();
        }
      } else {
        _navigationService.replaceWithWalkthroughView();
      }
    } catch (e) {
      print("❌ Force navigation failed: $e");
      // Absolute last resort
      try {
        _navigationService.replaceWithLoginView();
      } catch (_) {
        print("❌ All navigation attempts failed");
      }
    }
  }

  _initialSetup() async {
    try {
      // Initialize local storage first (needed for other operations)
      await _localStorageService.init();

      // Check connectivity (quick check)
      final connectivityCheck = Connectivity().checkConnectivity();
      
      // Start notification init (non-blocking for navigation)
      final notificationInit = _notificationService.initConfigure();
      
      // Wait for connectivity check with short timeout
      List<ConnectivityResult> connectivityResults;
      try {
        connectivityResults = await connectivityCheck.timeout(
          const Duration(seconds: 2),
          onTimeout: () => [ConnectivityResult.none],
        );
      } catch (e) {
        connectivityResults = [ConnectivityResult.none];
      }
      
      // Check if any connection is available
      // If list is empty or only contains 'none', there's no connection
      final hasConnection = connectivityResults.isNotEmpty && 
          connectivityResults.any((result) => result != ConnectivityResult.none);
      
      if (!hasConnection) {
        _showDialog();
        // Still navigate to login even without internet (user can retry)
        _navigationService.replaceWithLoginView();
        // Continue notification init in background
        notificationInit.catchError((e) {
          print("⚠️ Notification init error: $e");
          return null;
        });
        return;
      }

      // Determine navigation route immediately (don't wait for API calls)
      final isOnBoarding = _localStorageService.onBoarding;
      final isLogin = _authService.isLogin;
      
      // Start auth setup in background (non-blocking)
      final authSetup = _authService.doSetup();
      authSetup.catchError((e) {
        print("⚠️ Auth setup error: $e");
        return null;
      });
      
      // Navigate immediately - don't wait for API calls
      if (isOnBoarding) {
        if (isLogin) {
          // Check verification status after profile loads (non-blocking)
          authSetup.then((_) {
            if (_authService.userProfile?.verified == 0) {
              // Navigate to email verification if needed
              _navigationService.navigateToEmailVerificationView(
                  email: _authService.userProfile?.email ?? "");
            }
          }).catchError((e) {
            print("⚠️ Auth check error: $e");
            return null;
          });
          
          // Navigate to root view immediately
          _navigationService.replaceWithRootView();
        } else {
          _localStorageService.address = null;
          _localStorageService.addressId = null;
          _navigationService.replaceWithLoginView();
        }
      } else {
        _navigationService.replaceWithWalkthroughView();
      }
      
      // Continue notification init in background
      notificationInit.catchError((e) {
        print("⚠️ Notification init error: $e");
        return null;
      });
    } catch (e, stackTrace) {
      print("❌ Startup Error: $e");
      print("❌ Stack Trace: $stackTrace");
      
      // Fallback navigation - always navigate somewhere
      try {
        // Safely check if services are initialized
        bool onBoarding = false;
        bool isLogin = false;
        
        try {
          onBoarding = _localStorageService.onBoarding;
        } catch (_) {
          // Service not initialized, default to false
        }
        
        try {
          isLogin = _authService.isLogin;
        } catch (_) {
          // Service not initialized, default to false
        }
        
        if (onBoarding) {
          if (isLogin) {
            _navigationService.replaceWithRootView();
          } else {
            _navigationService.replaceWithLoginView();
          }
        } else {
          _navigationService.replaceWithWalkthroughView();
        }
      } catch (navError) {
        print("❌ Navigation Error: $navError");
        // Last resort - try to navigate to login
        try {
          _navigationService.replaceWithLoginView();
        } catch (e) {
          print("❌ Critical Navigation Failure: $e");
        }
      }
    }
  }

  _showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.noInternet,
      title: 'No Internet',
      description:
          "You have no internet connection! please connect to internet",
    );
  }
}

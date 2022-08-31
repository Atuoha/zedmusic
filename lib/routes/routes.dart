import 'package:zedmusic/screens/auth/auth.dart';
import 'package:zedmusic/screens/auth/forgot_password.dart';
import 'package:zedmusic/screens/main/bottom_nav.dart';
import 'package:zedmusic/screens/splash/splash.dart';

var routes =
  {
    SplashScreen.routeName: (context) => const SplashScreen(),
    AuthScreen.routeName: (context)=> const AuthScreen(),
    ForgotPasswordScreen.routeName: (context)=> const ForgotPasswordScreen(),
    BottomNav.routeName: (context)=> const BottomNav(),
  }
;
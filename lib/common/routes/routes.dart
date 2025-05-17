import 'package:go_router/go_router.dart';
import '../../features/auth/login/pages/login_page.dart';
import '../../features/auth/otp_confirm/page/otp_confirm_page.dart';
import '../../features/auth/sign_up/pages/signup_page.dart';
import '../../features/splash/splash_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (context, state) {
        return SplashPage();
      },
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      name: 'signup',
      path: '/signup',
      builder: (context, state) {
        return SignupPage();
      },
    ),
    GoRoute(
      name: 'confirm-otp',
      path: '/confirm-otp',
      builder: (context, state) {
        return OtpConfirmPage();
      },
    ),
  ],
);

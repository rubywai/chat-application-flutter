import 'package:chat_application/features/home/chat_list/page/chat_list_page.dart';
import 'package:chat_application/features/home/contacts/page/contact_page.dart';
import 'package:chat_application/features/home/home_page.dart';
import 'package:chat_application/features/home/settings/page/setting_page.dart';
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) {
        return HomePage(shell: shell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'contact',
              path: '/contact',
              builder: (context, state) {
                return ContactPage();
              },
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'chat-list',
              path: '/chat-list',
              builder: (context, state) {
                return ChatListPage();
              },
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'settings',
              path: '/settings',
              builder: (context, state) {
                return SettingPage();
              },
            ),
          ],
        ),
      ],
    )
  ],
);

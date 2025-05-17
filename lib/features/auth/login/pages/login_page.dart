import 'package:chat_application/common/theme/extension/color_brand.dart';
import 'package:chat_application/common/widgets/brand_button.dart';
import 'package:chat_application/features/auth/login/notifier/login_notifier.dart';
import 'package:chat_application/features/auth/login/notifier/login_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _loginForm = GlobalKey();
  final LoginProvider _loginProvider = LoginProvider(() => LoginNotifier());
  String? _email;
  String? _password;
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = TextTheme.of(context);

    ColorBrand colorBrand = Theme.of(context).extension<ColorBrand>()!;

    LoginNotifier notifier = ref.read(_loginProvider.notifier);
    LoginStateModel stateModel = ref.watch(_loginProvider);

    bool isLoading = stateModel.isLoading;
    bool isFailed = stateModel.isFailed;
    bool isSuccess = stateModel.isSuccess;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (isFailed)
            Center(
              child: Column(
                children: [
                  Text(stateModel.errorMessage),
                  SizedBox(
                    height: 8.0,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      notifier.tryAgain();
                    },
                    child: Text("Try Again"),
                  ),
                ],
              ),
            ),
          if (isSuccess)
            Center(
              child: Text(
                "Login Success",
                style: TextStyle(color: Colors.green),
              ),
            ),
          if (!isLoading && !isSuccess && !isFailed)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _loginForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                      validator: (String? email) {
                        if (email != null &&
                            email.length < 3 &&
                            !email.contains('@')) {
                          return "Please enter email correctly";
                        }
                        return null;
                      },
                      onSaved: (String? email) {
                        _email = email;
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                      validator: (String? password) {
                        if (password != null && password.length < 6) {
                          return "Please enter min 6 chars";
                        }
                        return null;
                      },
                      onSaved: (String? password) {
                        _password = password;
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    BrandButton(
                      text: 'Login',
                      onPressed: () {
                        final state = _loginForm.currentState;
                        state?.save();
                        if (state?.validate() == true) {
                          notifier.login(
                            email: _email!,
                            password: _password!,
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New user?',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        InkWell(
                          onTap: () {
                            context.push("/signup");
                          },
                          child: Text(
                            'Sign up',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorBrand.brandDefault,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

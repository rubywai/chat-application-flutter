import 'package:chat_application/features/auth/sign_up/notifier/signup_notifier.dart';
import 'package:chat_application/features/auth/sign_up/notifier/signup_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/theme/extension/color_brand.dart';
import '../../../../common/widgets/brand_button.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  bool _isRedirect = false;
  final SignupProvider _signupProvider = SignupProvider(() => SignupNotifier());
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    SignupStateModel stateModel = ref.watch(_signupProvider);
    bool isLoading = stateModel.isLoading;
    bool isFailed = stateModel.isFailed;
    bool isSuccess = stateModel.isSuccess;

    bool isFormState = !isLoading && !isFailed && !isSuccess;

    ref.listen(_signupProvider, (oldState, newState) {
      if (newState.isSuccess && !_isRedirect) {
        _isRedirect = true;
        Future.delayed(Duration(seconds: 1)).then((v) {
          if (context.mounted) {
            Navigator.pop(context);
            context.pushNamed(
              'confirm-otp',
              extra: _email,
            );
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (isFailed) _failed(),
          if (isSuccess) _success(),
          if (isFormState) _form(),
        ],
      ),
    );
  }

  Widget _form() {
    TextTheme textTheme = TextTheme.of(context);
    ColorBrand colorBrand = Theme.of(context).extension<ColorBrand>()!;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    SignupNotifier notifier = ref.read(_signupProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _signUpFormKey,
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
                hintText: 'Name',
              ),
              validator: (String? name) {
                if (name != null && name.length < 3) {
                  return "Please enter name above 3 characters";
                }
                return null;
              },
              onSaved: (String? name) {
                _name = name;
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
                hintText: 'Email',
              ),
              validator: (String? email) {
                if (email != null && email.length < 3 && !email.contains('@')) {
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
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: InputBorder.none,
                hintText: 'Password',
              ),
              validator: (String? password) {
                if (password != null && password.length < 6) {
                  return "Please enter minimum password 6 chars";
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
              text: 'Sign up',
              onPressed: () {
                FormState? state = _signUpFormKey.currentState;
                state?.save();
                if (state?.validate() == true) {
                  notifier.signup(
                    name: _name!,
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
                  'Already have an account?',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
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
    );
  }

  Widget _failed() {
    SignupStateModel stateModel = ref.watch(_signupProvider);
    SignupNotifier notifier = ref.read(_signupProvider.notifier);
    return Center(
      child: Column(
        children: [
          Text(stateModel.errorMessage),
          SizedBox(
            height: 16,
          ),
          OutlinedButton(
            onPressed: () {
              if (stateModel.errorMessage == 'OTP already sent.') {
                notifier.otpRequest(_email!);
              } else if (stateModel.errorMessage ==
                  'Email is already verified.') {
                Navigator.pop(context);
              } else {
                notifier.tryAgain();
              }
            },
            child: Text(
              notifier.failedButtonText(stateModel.errorMessage),
            ),
          )
        ],
      ),
    );
  }

  Widget _success() {
    return Center(
      child: Column(
        children: [
          Text(
            'Success',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

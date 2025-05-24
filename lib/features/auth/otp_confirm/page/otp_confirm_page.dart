import 'package:chat_application/features/auth/otp_confirm/notifier/otp_confirm_notifier.dart';
import 'package:chat_application/features/auth/otp_confirm/notifier/otp_confirm_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OtpConfirmPage extends ConsumerStatefulWidget {
  const OtpConfirmPage({super.key});

  @override
  ConsumerState<OtpConfirmPage> createState() => _OtpConfirmPageState();
}

class _OtpConfirmPageState extends ConsumerState<OtpConfirmPage> {
  final OtpConfirmProvider _otpConfirmProvider =
      OtpConfirmProvider(() => OtpConfirmNotifier());
  bool _isRedirect = false;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    GoRouterState state = GoRouterState.of(context);
    String? email = state.extra?.toString();

    OtpConfirmNotifier notifier = ref.read(_otpConfirmProvider.notifier);
    OtpConfirmStateModel stateModel = ref.watch(_otpConfirmProvider);

    bool isLoading = stateModel.isLoading;
    bool isSuccess = stateModel.isSuccess;
    bool isFailed = stateModel.isFailed;

    ref.listen(_otpConfirmProvider, (oldState, newState) {
      if (newState.isSuccess && !_isRedirect) {
        _isRedirect = true;
        context.go("/login");
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text("Confirm your OTP"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (isSuccess)
            Center(
              child: Text(
                'Success',
                style: TextStyle(color: Colors.green),
              ),
            ),
          if (isFailed)
            Center(
              child: Column(
                children: [
                  Text('Failed'),
                  SizedBox(
                    height: 8.0,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      notifier.tryAgain();
                    },
                    child: Text('Try Again'),
                  ),
                ],
              ),
            ),
          if (!isLoading && !isSuccess && !isFailed)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Enter Code',
                      style: textTheme.displayMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'We have sent you an OTP with the code to $email',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: InputBorder.none,
                        hintText: 'Please Enter 4 digits',
                      ),
                      onSubmitted: (String? otp) {
                        if (otp != null && otp.length == 4) {
                          notifier.verifyEmail(
                            email: email!,
                            otpCode: otp,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter 4 digits'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

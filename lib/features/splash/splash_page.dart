import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/brand_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset("assets/images/logo.png"),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'Connect easily with your family and friends over countries',
                    style: textTheme.displayMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Terms & Privacy Policy',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  BrandButton(
                    text: 'Start Messaging',
                    onPressed: () {
                      context.push('/login');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

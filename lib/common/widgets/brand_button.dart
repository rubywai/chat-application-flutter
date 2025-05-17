import 'package:flutter/material.dart';

import '../theme/extension/color_brand.dart';
import '../theme/extension/color_neutral.dart';

class BrandButton extends StatelessWidget {
  const BrandButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    ColorBrand colorBrand = Theme.of(context).extension<ColorBrand>()!;
    ColorNeutral colorNeutral = Theme.of(context).extension<ColorNeutral>()!;
    double width = MediaQuery.of(context).size.width;
    return FilledButton(
      style: FilledButton.styleFrom(
        fixedSize: Size.fromWidth(width - 32),
        backgroundColor: colorBrand.brandDefault,
        textStyle: textTheme.bodyLarge?.copyWith(
          color: colorNeutral.buttonText,
        ),
        foregroundColor: colorNeutral.buttonText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

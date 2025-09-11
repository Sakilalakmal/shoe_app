import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';

class ReadMoreTextWidget extends StatefulWidget {
  final String text;
  final int trimLength;

  const ReadMoreTextWidget({
    super.key,
    required this.text,
    this.trimLength = 150, // Adjust as needed
  });

  @override
  State<ReadMoreTextWidget> createState() => _ReadMoreTextWidgetState();
}

class _ReadMoreTextWidgetState extends State<ReadMoreTextWidget> {
  bool isExpanded = false;

 @override
Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme.bodyMedium;
  final shouldTrim = widget.text.length > widget.trimLength;

  String visibleText;
  String toggleText = isExpanded ? ' Read less' : ' Read more';

  if (shouldTrim && !isExpanded) {
    visibleText = widget.text.substring(0, widget.trimLength).trim() + '...';
  } else {
    visibleText = widget.text;
  }

  return RichText(
    text: TextSpan(
      style: textTheme,
      children: [
        TextSpan(text: visibleText),
        if (shouldTrim)
          TextSpan(
            text: toggleText,
            style: textTheme?.copyWith(
              color: TColors.newBlue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
          ),
      ],
    ),
  );
}

}

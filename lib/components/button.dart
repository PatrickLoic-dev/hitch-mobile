import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon; // Optional icon widget
  final TextStyle? textStyle; // Optional text style
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ButtonStyle? style; // Allow full style override if needed

  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Define your default style properties
    final defaultBackgroundColor = backgroundColor ?? Color(0xFFA6EB2E);
    final defaultForegroundColor = foregroundColor ?? Colors.black;
    final defaultTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontFamily: 'Jokker', // Uncomment if you have this font
    ).merge(textStyle); // Merge with any provided textStyle

    // Create the button's content, with an optional icon
    final buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // So the row doesn't stretch unnecessarily
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8), // Space between icon and text
        ],
        Text(text),
      ],
    );

    // Build the final button style by merging everything
    final effectiveStyle = ElevatedButton.styleFrom(
      backgroundColor: defaultBackgroundColor,
      foregroundColor: defaultForegroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: defaultTextStyle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      // MODIFICATION : Ajout de cette ligne pour supprimer l'ombre
      elevation: 0,
    ).merge(style); // Allow external style to override defaults

    return ElevatedButton(
      onPressed: onPressed,
      style: effectiveStyle,
      child: buttonContent,
    );
  }
}

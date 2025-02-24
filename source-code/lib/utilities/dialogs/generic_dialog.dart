// ignore_for_file: prefer_const_constructors

import 'package:fatiel/constants/colors/theme_colors.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ThemeColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ThemeColors.blackColor,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ThemeColors.blackColor,
          ),
        ),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              Navigator.of(context).pop(value);
            },
            style: TextButton.styleFrom(
              foregroundColor: ThemeColors.primaryColor,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}

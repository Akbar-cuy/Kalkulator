import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle display = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle h1 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle h2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle body = TextStyle(fontSize: 14, color: AppColors.textPrimary);
  static const TextStyle label = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textMuted);
  static const TextStyle caption = TextStyle(fontSize: 12, color: AppColors.textMuted);
  static const TextStyle button = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white);
}

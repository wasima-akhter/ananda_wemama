import 'package:flutter/material.dart';
import 'package:get/get.dart';

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }

  const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regex = RegExp(emailPattern);

  if (!regex.hasMatch(value.trim())) {
    return 'Enter a valid email address';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  // if (value.length < 8) {
  //   return 'Password must be at least 8 characters';
  // }

  // const passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$';
  // final regex = RegExp(passwordPattern);

  // if (!regex.hasMatch(value)) {
  //   return 'Password must include upper, lower, number \n& special character';
  // }

  return null;
}

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Name is required';
  }

  if (value.length < 3) {
    return 'Name must be at least 3 characters';
  }

  return null;
}

String? validateDescription(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Content is required';
  }

  if (value.length < 10) {
    return 'Content must be at least 10 characters';
  }

  return null;
}

String? validateBioDescription(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Content is required';
  }

  if (value.length > 250) {
    return 'Content can be upto 250 characters';
  }

  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Phone number is required";
  }

  final phone = value.trim();

  // Remove spaces, dashes etc. for validation
  final cleaned = phone.replaceAll(RegExp(r'\s+|-'), '');

  // General international phone pattern (supports + and 7–15 digits)
  final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  if (!phoneRegex.hasMatch(cleaned)) {
    return "Enter a valid phone number";
  }

  return null; // ✅ valid
}

String? validateConfirmPass({
  required String? confirmPass,
  required String password,
}) {
  if (confirmPass == null || confirmPass.trim().isEmpty) {
    return "Confirm password is required";
  }

  if (password.trim() != confirmPass.trim()) {
    return "Passwords do not match";
  }

  return null; // ✅ valid
}

bool validateForm(GlobalKey<FormState> formkey) {
  final isValid = formkey.currentState?.validate() ?? false;
  return isValid;
}

bool isValidUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  try {
    final uri = Uri.parse(url);
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  } catch (_) {
    return false;
  }
}

Worker bindValidation({required RxString value, required RxString error}) {
  return ever(value, (String v) {
    if (v.trim().isNotEmpty) {
      error.value = '';
    }
  });
}

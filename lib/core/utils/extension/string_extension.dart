import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mama_app/core/config/app_info.dart';
import 'package:mama_app/core/utils/extension/context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../enums/app_enums.dart';

extension ShowToastExtension on String {
  showToast({bgColor, txtColor}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: this,
      backgroundColor: bgColor ?? c.cardPrimary,
      fontSize: 16,
      gravity: ToastGravity.BOTTOM,
      textColor: txtColor ?? Colors.black54,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 1,
    );
  }

  Widget onClick({VoidCallback? method}) {
    return GestureDetector(onTap: method ?? () {}, child: Text(this));
  }
}

// extension TokenValidationExtension on String {
//   bool get isInvalid {
//     return this != LocalStorageService.instance.getToken.toString();
//   }
// }

extension shortTimeAgoExtension on String {
  String get shortenAgoTxt {
    return replaceAll('minutes ago', 'min ago')
        .replaceAll('minute ago', 'min ago')
        .replaceAll('hours ago', 'hr ago')
        .replaceAll('hour ago', 'hr ago')
        .replaceAll('seconds ago', 'sec ago')
        .replaceAll('second ago', 'sec ago')
        .replaceAll('months ago', 'm ago')
        .replaceAll('month ago', 'm ago')
        .replaceAll('weeks ago', 'w ago')
        .replaceAll('week ago', 'w ago')
        .replaceAll('days ago', 'd ago')
        .replaceAll('years ago', 'y ago');
    // "days" and "weeks" are unchanged
  }
}

extension BuildEmailBodyExtension on String {
  Widget get buildEmailBody {
    final bodyHtml = this;

    if (bodyHtml.isNotEmpty) {
      final cleanedHtml = bodyHtml
          .replaceAll(RegExp(r'^<!DOCTYPE[^>]*>'), '')
          .replaceAll(RegExp(r'<html[^>]*>|</html>'), '');
      // .replaceAll(RegExp(r'<body[^>]*>|</body>'), '');

      return SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Html(
            data: cleanedHtml,
            style: {
              "body": Style(
                fontFamily: 'Helvetica, Arial, sans-serif',
                fontSize: FontSize(16),
                color: Colors.black87,
                lineHeight: LineHeight.number(1.5),
              ),
              "p": Style(margin: Margins.only(bottom: 12)),
              "a": Style(color: Colors.blue, textDecoration: TextDecoration.underline),
            },
            onLinkTap: (url, _, __) async {
              if (url == null) return;
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
          ),
        ),
      );
    }

    return const SizedBox();
  }
}

extension BodyPlainConvertExtension on String {
  Widget get convertBodyPlain {
    final lines = split('\n').where((line) => line.trim().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => _parseLine(line.trim())).toList(),
    );
  }

  Widget _parseLine(String line) {
    // ✅ Detect invoice illustration with image
    final imageMatch = RegExp(r'\[https?:\/\/[^\]]+\]').firstMatch(line);
    if (imageMatch != null) {
      final url = imageMatch.group(0)!.replaceAll(RegExp(r'[\[\]]'), '');
      return SizedBox(child: Image.network(url, height: 120));
    }

    // ✅ Detect link in parentheses
    final linkMatch = RegExp(r'\(https?:\/\/[^\)]+\)').firstMatch(line);
    if (linkMatch != null) {
      final url = linkMatch.group(0)!.replaceAll(RegExp(r'[\(\)]'), '');
      final text = line.replaceAll(linkMatch.group(0)!, '').trim();
      return TextButton(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          text.isNotEmpty ? text : url,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: TextStyle(
            fontFamily: "Inter-Regular",
            fontSize: 13,
            color: c.primary,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
      );
    }

    // ✅ Default: normal text
    return Text(
      line,
      softWrap: true,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontFamily: "Inter",
        fontSize: 13,
        color: c.primary,
        fontWeight: FontWeight.w400,
        height: 1.2,
      ),
    );
  }

  String get getFirstThreeLines {
    // Split into lines and remove empty ones
    final lines = split('\n').where((line) => line.trim().isNotEmpty).toList();

    // Take first 3 lines only
    final firstThree = lines.take(3).toList();

    // Join them back as a single string
    return firstThree.join('\n');
  }

  /// Returns the first non-empty line, splitting by '\n' or <p> tags.
  String get getFirstOneLine {
    final lines = split(
      RegExp(r'(?:\n|</p>|<ul>)'),
    ).map((line) => line.trim()).where((line) => line.isNotEmpty).toList();

    return lines.isNotEmpty ? lines.first : '';
  }
}

extension GetIndianFormat on String {
  String get formatIndianNumber {
    String numStr = num.parse(this).toStringAsFixed(0); // integer only
    int len = numStr.length;

    if (len <= 3) return numStr;

    // Split last 3 digits
    String last3 = numStr.substring(len - 3);
    String rest = numStr.substring(0, len - 3);

    // Add commas every two digits in the rest part
    final buffer = StringBuffer();
    int count = 0;

    for (int i = rest.length - 1; i >= 0; i--) {
      buffer.write(rest[i]);
      count++;
      if (count == 2 && i != 0) {
        buffer.write(',');
        count = 0;
      }
    }

    // Reverse the processed rest part
    String formattedRest = buffer.toString().split('').reversed.join('');

    return "$formattedRest,$last3";
  }
}

extension GetUrlExt on String {
  String get getUrl => baseUrl + routeInitial + this;
}

extension UserRoleExt on UserRole {
  String get value {
    switch (this) {
      case UserRole.customer:
        return "Customer";
      case UserRole.supplier:
        return "Supplier";
      case UserRole.admin:
        return "Admin";
    }
  }

  static UserRole? fromString(String? roleStr) {
    switch (roleStr?.toLowerCase()) {
      case "customer":
        return UserRole.customer;
      case "supplier":
        return UserRole.supplier;
      case "admin":
        return UserRole.admin;
      default:
        return null; // unknown role
    }
  }
}

// New extension for conversion
extension UserRoleFromString on String {
  UserRole? toUserRole() {
    switch (toLowerCase()) {
      case "customer":
        return UserRole.customer;
      case "supplier":
        return UserRole.supplier;
      case "admin":
        return UserRole.admin;
      default:
        return UserRole.customer; // fallback if backend sends unexpected value
    }
  }
}

extension CustomerOrderCategoryX on CustomerOrderCategory {
  /// Map a string to enum safely
  static CustomerOrderCategory orderStatusToEnum(String? status) {
    if (status == null) return CustomerOrderCategory.pending;
    return CustomerOrderCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == status.toLowerCase(),
      orElse: () => CustomerOrderCategory.canceled,
    );
  }
}

extension SupplierOrderActionExt on SupplierOrderAction {
  String get endpoint {
    switch (this) {
      case SupplierOrderAction.accept:
        return "accept-order";
      case SupplierOrderAction.onTheWay:
        return "order-on-the-way";
      case SupplierOrderAction.complete:
        return "complete-order";
      case SupplierOrderAction.delete:
        return "delete-order";
      case SupplierOrderAction.confirm:
        return "confirm-order";
      case SupplierOrderAction.reject:
        return "reject-order";
      case SupplierOrderAction.cancel:
        return "cancel-order";
    }
  }
}

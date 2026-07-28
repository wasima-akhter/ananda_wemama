import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:we_mama/core/config/app_info.dart';
import 'package:we_mama/core/utils/extension/context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../features/main_tabs/community/core/models/community_item_model.dart';
import '../../constants/strings.dart';
import '../../enums/ui_enums.dart';

extension ShowToastExtension on String {
  void showToast({bgColor, txtColor}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: this,
      backgroundColor: bgColor ?? c.cardPrimary,
      fontSize: 16,
      gravity: ToastGravity.BOTTOM,
      textColor: txtColor ?? c.primary,
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
              "a": Style(
                color: Colors.blue,
                textDecoration: TextDecoration.underline,
              ),
            },
            onLinkTap: (url, _, _) async {
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

extension CommunityItemX on CommunityItemModel {
  MyCommunityBtnState get btnState {
    if (isCreator == true) return MyCommunityBtnState.manage;
    if (isMember == true) return MyCommunityBtnState.visit;
    return MyCommunityBtnState.join;
  }

  String get btnText {
    switch (btnState) {
      case MyCommunityBtnState.manage:
        return Strings.manage;
      case MyCommunityBtnState.visit:
        return Strings.visit;
      case MyCommunityBtnState.join:
        return Strings.join;
    }
  }
}

extension DateTimeExtensions on DateTime {
  String get formatMMMMdyyyy => DateFormat('d MMMM yyyy').format(this);
}

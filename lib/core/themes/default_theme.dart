// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'button_styles.dart';
// import 'color/color_model.dart';
// import 'theme_service.dart';

// class DefaultTheme {
//   themeData(ThemeController themeServIns, ColorModel themeColors, BuildContext contxt) {
//     return ThemeData(
//       useMaterial3: true,
//       appBarTheme: appBarTheme(themeServIns, themeColors, contxt),
//       colorScheme: ColorScheme.fromSeed(seedColor: contxt.colors.primaryColor),
//       checkboxTheme: checkboxThemeData(),
//       inputDecorationTheme: inputDecorationTheme(contxt),
//       elevatedButtonTheme: elevatedButtonThemeData(contxt),
//       scaffoldBackgroundColor: contxt.colors.backgroundColor,
//       //
//       textTheme: textThemeData(),
//       textButtonTheme: TextButtonThemeData(),
//       scrollbarTheme: ScrollbarThemeData(),
//       bottomSheetTheme: BottomSheetThemeData(),
//       popupMenuTheme: PopupMenuThemeData(),
//       switchTheme: SwitchThemeData(),
//       radioTheme: RadioThemeData(),
//       outlinedButtonTheme: OutlinedButtonThemeData(),
//     );
//   }

//   appBarTheme(ThemeController themeServIns, ColorModel themeColors, BuildContext contxt) =>
//       AppBarTheme(
//         surfaceTintColor: themeColors.primaryBorderColor,
//         backgroundColor: themeColors.backgroundColor,
//         foregroundColor: themeColors.primaryContrastColor,
//         elevation: 3,
//         titleTextStyle: contxt.customInter(w: 400, 18),
//         systemOverlayStyle: SystemUiOverlayStyle(
//           statusBarColor: cc.backgroundColor,
//           statusBarIconBrightness: Brightness.light,
//         ),
//       );

//   elevatedButtonThemeData(BuildContext context) =>
//       ElevatedButtonThemeData(style: ButtonStyles().primaryClr(context));

//   checkboxThemeData() => CheckboxThemeData(
//     checkColor: WidgetStateColor.resolveWith((states) => cwhite),
//     fillColor: WidgetStateColor.resolveWith((states) {
//       if (states.contains(WidgetState.selected)) return Colors.blue[300]!;
//       if (states.contains(WidgetState.hovered)) return Colors.blue[100]!;
//       return Colors.grey[300]!;
//     }),
//     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 🔹 removes extra tap padding
//     visualDensity: VisualDensity.compact, // 🔹 tightens layout vertically & horizontally
//   );

//   inputDecorationTheme(BuildContext contxt) => InputDecorationTheme(
//     hintStyle: contxt.customInter(w: 400, 14),
//     border: OutlineInputBorder(borderSide: BorderSide(color: cgreyblue)),
//   );

//   textThemeData() => TextTheme(
//     bodySmall: GoogleFonts.inter(fontWeight: FontWeight.w400),
//     bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w500),
//     bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
//     titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w700),
//     titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w800),
//     displayLarge: GoogleFonts.inter(fontWeight: FontWeight.w900),
//   );
// }

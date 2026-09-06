import '../../app/helper_widgets_export.dart';

TextStyle get titleBPri =>
    TxtStyle.interSemiB(fs: 14, w: 600, color: c.primary);
TextStyle get titleSmBPri =>
    TxtStyle.interSemiB(fs: 13, w: 600, color: c.primary);

TextStyle get normRPri => TxtStyle.inter(fs: 14, w: 400, color: c.primary);

TextStyle get normRsmPri => TxtStyle.inter(fs: 13, w: 400, color: c.primary);
TextStyle get normRsmSec =>
    TxtStyle.inter(fs: 13, w: 400, color: c.textSecondary);

TextStyle get normSmBPri =>
    TxtStyle.interSemiB(fs: 13, w: 500, color: c.primary);

////////////////Urbanist
TextStyle get titleBPriURB =>
    TxtStyle.urbanistSemiB(fs: 14, w: 600, color: c.strokePrimary);
TextStyle get titleSmBPriURB =>
    TxtStyle.urbanistSemiB(fs: 13, w: 600, color: c.primary);

TextStyle get normRPriURB =>
    TxtStyle.urbanist(fs: 14, w: 400, color: c.primary);

TextStyle get normRsmPriURB =>
    TxtStyle.urbanist(fs: 12, w: 400, color: c.foregroundPrimary);
TextStyle get normRsmSecURB =>
    TxtStyle.urbanist(fs: 12, w: 400, color: c.foregroundPrimary);

TextStyle get normSmBPriURB =>
    TxtStyle.urbanistSemiB(fs: 13, w: 500, color: c.primary);

////////////////Outfit
TextStyle get title_600_mClr_Outfit =>
    TxtStyle.outfitSemiB(fs: 14, w: 600, color: c.primary);
TextStyle get title_Sm_600_mClr_Outfit =>
    TxtStyle.outfitSemiB(fs: 13, w: 600, color: c.primary);

TextStyle get norm_mClr_Outfit =>
    TxtStyle.outfit(fs: 14, w: 400, color: c.primary);

TextStyle get norm_Sm_mClr_Outfit =>
    TxtStyle.outfit(fs: 13, w: 400, color: c.primary);
TextStyle get norm_Sm_Sec_Outfit =>
    TxtStyle.outfit(fs: 13, w: 400, color: c.textSecondary);

TextStyle get norm_Sm_500_mClr_Outfit =>
    TxtStyle.outfitSemiB(fs: 13, w: 500, color: c.primary);

double measureTextHeight(String text, TextStyle style) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.height;
}

bool isTextOverflowing({
  required String text,
  required TextStyle style,
  required double maxWidth,
  required int maxLines,
}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  return textPainter.didExceedMaxLines;
}

class StateAndCityData {
  /// 🇳🇬 All 36 States + FCT
  static const List<String> states = [
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross River",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    "FCT - Abuja",
    "Gombe",
    "Imo",
    "Jigawa",
    "Kaduna",
    "Kano",
    "Katsina",
    "Kebbi",
    "Kogi",
    "Kwara",
    "Lagos",
    "Nasarawa",
    "Niger",
    "Ogun",
    "Ondo",
    "Osun",
    "Oyo",
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara",
  ];

  /// 🏙 Major Cities grouped by State (Better structure)
  static const Map<String, List<String>> citiesByState = {
    "Abia": ["Umuahia", "Aba", "Ohafia"],
    "Adamawa": ["Yola", "Mubi", "Numan"],
    "Akwa Ibom": ["Uyo", "Eket", "Ikot Ekpene"],
    "Anambra": ["Awka", "Onitsha", "Nnewi", "Ekwulobia"],
    "Bauchi": ["Bauchi", "Azare", "Misau"],
    "Bayelsa": ["Yenagoa", "Ogbia", "Brass"],
    "Benue": ["Makurdi", "Gboko", "Otukpo"],
    "Borno": ["Maiduguri", "Biu", "Bama"],
    "Cross River": ["Calabar", "Ikom", "Ogoja"],
    "Delta": ["Asaba", "Warri", "Sapele", "Ughelli"],
    "Ebonyi": ["Abakaliki", "Afikpo"],
    "Edo": ["Benin City", "Auchi", "Ekpoma"],
    "Ekiti": ["Ado Ekiti", "Ikere Ekiti"],
    "Enugu": ["Enugu", "Nsukka", "Agbani"],
    "FCT - Abuja": ["Gwarinpa", "Maitama", "Wuse", "Asokoro", "Kubwa"],
    "Gombe": ["Gombe", "Kaltungo"],
    "Imo": ["Owerri", "Orlu", "Okigwe"],
    "Jigawa": ["Dutse", "Hadejia"],
    "Kaduna": ["Kaduna", "Zaria", "Kafanchan"],
    "Kano": ["Kano", "Fagge", "Gwale"],
    "Katsina": ["Katsina", "Daura", "Funtua"],
    "Kebbi": ["Birnin Kebbi", "Argungu"],
    "Kogi": ["Lokoja", "Okene", "Kabba"],
    "Kwara": ["Ilorin", "Offa"],
    "Lagos": ["Ikeja", "Lekki", "Surulere", "Ikorodu", "Epe"],
    "Nasarawa": ["Lafia", "Keffi", "Akwanga"],
    "Niger": ["Minna", "Bida", "Suleja"],
    "Ogun": ["Abeokuta", "Ijebu Ode", "Sagamu", "Ota"],
    "Ondo": ["Akure", "Ondo Town", "Owo"],
    "Osun": ["Osogbo", "Ile-Ife", "Ilesa"],
    "Oyo": ["Ibadan", "Ogbomosho", "Oyo Town"],
    "Plateau": ["Jos", "Bukuru"],
    "Rivers": ["Port Harcourt", "Obio-Akpor", "Bonny"],
    "Sokoto": ["Sokoto", "Tambuwal"],
    "Taraba": ["Jalingo", "Wukari"],
    "Yobe": ["Damaturu", "Potiskum"],
    "Zamfara": ["Gusau", "Talata Mafara"],
  };

  /// 🔹 Helper to get cities safely
  static List<String> getCities(String state) {
    return citiesByState[state] ?? [];
  }
}

String getFirstWord(String text) {
  if (text.trim().isEmpty) return '';

  return text.trim().split(RegExp(r'\s+')).first;
}

double findTextWidth({
  required String text,
  required TextStyle style,
  int maxLines = 1,
}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width;
}

Widget linkText(String text, {void Function()? onTap}) {
  return CusGestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: Text(
            text,
            style: TxtStyle.poppinsSemiB(
              w: 700,
              color: c.foregroundSecondary,
              fs: 11,
            ).copyWith(height: 1),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(height: 1, color: c.foregroundSecondary),
        ),
      ],
    ),
  );
}

//

bool willTextOverflow({
  required String text,
  required TextStyle style,
  double? maxWidth,
  int maxLines = 1,
}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth ?? 1.sw - 30.w);

  return textPainter.didExceedMaxLines ||
      textPainter.width > (maxWidth ?? 1.sw - 30.w);
}

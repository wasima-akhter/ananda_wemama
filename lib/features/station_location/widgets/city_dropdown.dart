import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../app/helper_widgets_export.dart'; // your colors like bgClr

class CityDropdown extends StatelessWidget {
  final Widget? frontWidget; // customizable front widget
  final double? width;
  final double? height;
  final String selectedCity;
  final List<String> cities;
  final void Function(String city) setSelectedCity;

  const CityDropdown({
    super.key,
    this.frontWidget,
    this.width,
    this.height,
    required this.setSelectedCity,
    required this.selectedCity,
    required this.cities,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownWidth = width ?? S.w - 20;
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: 8.brdrRad,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          value: selectedCity.isEmpty ? null : selectedCity,
          hint: frontWidget ?? const Text("Select a city"),
          items: cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
          onChanged: (value) {
            if (value != null) setSelectedCity(value);
          },

          // ✅ Dropdown styling
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: bgClr,
              borderRadius: 8.brdrRad,
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            maxHeight: 300,
            width: dropdownWidth,
            offset: Offset(0, height ?? 0),
            // ⬇ force dropdown below the button
            isOverButton: false,

            // Add space outside the dropdown
          ),

          // ✅ Button style (makes frontWidget fully customizable)
          buttonStyleData: ButtonStyleData(
            height: height ?? 50,
            width: width ?? 200,
            padding: EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
    );
  }
}



/* call it
       CityDropdown(
                  cities: slc.cities,
                  selectedCity: slc.selectedCity.value,
                  setSelectedCity: slc.setSelectedCity,
                  frontWidget: Row(
                    children: [
                      SvgIcon(iconPath: IconsPath.locationFilled),
                      const SizedBox(width: 8),
                      Text(slc.selectedCity.value.isEmpty ? slc.cities[0] : slc.selectedCity.value),
                    ],
                  ),
                  // width: conte,
                );

                */
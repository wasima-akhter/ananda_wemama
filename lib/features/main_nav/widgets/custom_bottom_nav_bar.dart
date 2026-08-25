import '../../../app/helper_widgets_export.dart';
import '../controller/main_nav_controller.dart';
import 'navbar_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mnc = MainNavController.to;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: List.generate(mnc.pages.length, (index) {
        return Expanded(
          child: CusGestureDetector(
            onTap: () async => mnc.onTapIndex(index),
            child: Center(
              child: Obx(() {
                final currentIndex = mnc.currentIndex.value;
                final isCurrIndex = index == currentIndex;

                return NavbarItem(
                  iconPath: mnc.icons[index],
                  label: mnc.labels[index],
                  isSelected: isCurrIndex,
                  width: 24,
                  height: 24,
                  currenIndex: index,
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}

import '../../../app/helper_widgets_export.dart';
import '../controller/main_nav_controller.dart';
import 'navbar_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int length;
  final dynamic roleId;
  final MainNavController mnc;
  const CustomBottomNavBar({super.key, required this.length, this.roleId, required this.mnc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(length, (index) {
          return CusGestureDetector(
            onTap: () async => mnc.onTapIndex(index), // assign clicked index into currentIndex
            child: Obx(() {
              final currentIndex = mnc.currentIndex.value;
              final isCurrIndex = index == currentIndex;

              double w;
              double h;

              w = 20;
              h = 20;

              return ContainerBordered(
                contClr: c.inputBackground,
                hp: index == 3 ? 0 : 12,

                child: NavbarItem(
                  iconPath: mnc.icons[index],
                  label: mnc.labels[index],
                  isSelected: isCurrIndex,
                  width: w.w,
                  height: h.h,
                  currenIndex: index,
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

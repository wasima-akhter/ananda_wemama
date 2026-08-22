import '../../../../app/helper_widgets_export.dart';

class SelectListBottomSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final RxString selectedValue;
  final void Function(String value)? onSelect;
  final bool enableSearch;

  const SelectListBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    this.onSelect,
    this.enableSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    final RxList<String> filteredItems = items.obs;
    final searchCtrl = TextEditingController();

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: bgClr,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔹 Drag Indicator
            // Container(
            //   height: 4,
            //   width: S.w * 0.15,
            //   margin: const EdgeInsets.only(bottom: 16),
            //   decoration: BoxDecoration(color: c.inputBorder, borderRadius: 10.brdrRad),
            // ),
            Gap(itemGap * 3),

            /// 🔹 Title
            Text(
              title,
              style: TxtStyle.outfit(
                fs: 18,
                w: 600,
                color: c.foregroundSecondary,
              ),
            ),

            /// 🔹 Optional Search
            if (enableSearch) ...[
              Gap(itemGap),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: c.inputBackground,
                  borderRadius: 12.brdrRad,
                ),
                child: TextField(
                  controller: searchCtrl,
                  onChanged: (value) {
                    filteredItems.value = items
                        .where(
                          (e) => e.toLowerCase().contains(value.toLowerCase()),
                        )
                        .toList();
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: "Search...",
                  ),
                ),
              ),
            ],
            Gap(itemGap * 3),

            /// 🔹 List
            Flexible(
              child: Obx(() {
                if (filteredItems.isEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ContainerBordered(
                        vp: 22,
                        hp: 22,
                        contClr: inputBgClr,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "None is available.",
                          style: TxtStyle.outfitSemiB(
                            fs: 14,
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  separatorBuilder: (_, _) => Gap(itemGap * 0.9),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final isSelected = selectedValue.value == item;

                    return CusGestureDetector(
                      onTap: () {
                        selectedValue.value = item;
                        onSelect?.call(item);
                        Get.back();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? c.primary : c.cardPrimary,
                          borderRadius: 12.brdrRad,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item,
                                style: TxtStyle.outfitSemiB(
                                  fs: 14,
                                  color: isSelected
                                      ? white
                                      : c.foregroundSecondary,
                                ),
                              ),
                            ),

                            if (isSelected)
                              SvgIconColored(
                                iconPath: IconsPath.smallTick,
                                iconColor: white,
                                height: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

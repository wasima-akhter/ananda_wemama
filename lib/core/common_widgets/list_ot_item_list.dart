import '../../app/helper_widgets_export.dart';
import 'gesture_detector_cus.dart';
import 'models/common_data_models.dart';

class OrderItemList extends StatelessWidget {
  final List<SingleOrderDataModel?> list;
  final String? leftTitle;
  final String? rightTitle;
  final bool? hasDownArrow;
  final void Function()? onTapSupplierItem;
  final bool? hasShadow;
  final Color? brdrClr;
  final Color? titleTxtClr;
  const OrderItemList({
    super.key,
    required this.list,
    this.leftTitle,
    this.rightTitle,
    this.hasDownArrow,
    this.onTapSupplierItem,
    this.brdrClr,
    this.titleTxtClr,
    this.hasShadow,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 Duplicate testList only for UI testing
    final testList = [...list, ...list, ...list]; // 3x items

    return
    // name bar with sort of button
    // .. testList of items
    ListView.builder(
      physics: testList.length == 1
          ? NeverScrollableScrollPhysics()
          : AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: testList.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final title = testList[index]?.supplier?.name ?? '';
        final subTitle = (testList[index]?.fuelQuantity ?? 0).toString();
        final value = (testList[index]?.fuelPrice ?? 0).toString();
        final time = testList[index]?.createdAt?.day.toString() ?? '';
        return CusGestureDetector(
          onTap: onTapSupplierItem,
          child: ContainerBordered(
            // contClr: Colors.amber,
            hasBrdr: true,
            hp: 15,
            vp: 15,
            brdrClr: brdrClr,
            boxShadow: hasShadow == true ? boxShadowAllSides : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: componentTxtStyle),
                    if (subTitle != null) Text(subTitle, style: TxtStyle.inter(fs: 11)).mT(5),
                  ],
                ),
                Column(
                  children: [
                    if (value != null)
                      Text(value, style: TxtStyle.inter(fs: 11, w: 700, color: c.primary)),

                    if (time != null) Text(time, style: TxtStyle.inter(fs: 10)).mT(5),
                  ],
                ),
              ],
            ),
          ).mB(6),
        );
      },
    );
  }
}

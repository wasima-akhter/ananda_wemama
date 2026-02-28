import 'package:mama_app/app/service_export.dart';
import 'package:mama_app/core/common_widgets/empty_widget.dart';

import '../../../app/helper_widgets_export.dart';
import '../../helpers/date_helper.dart';
import '../gesture_detector_cus.dart';
import '../models/common_data_models.dart';

class OrderItemList extends StatelessWidget {
  final List<SingleOrderDataModel?> list;
  final String? leftTitle;
  final String? rightTitle;
  final bool? hasDownArrow;
  final void Function({
    required String customerOrderId,
    required CustomerOrderCategory orderStatus,
  })?
  onTapSupplierItem;
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
    final testList = [...list]; // 3x items

    if (testList.isEmpty) {
      return EmptyWidget(title: Strings.noItemFound);
    }

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
        final fuelQuantity = (testList[index]?.fuelQuantity ?? 0).toString();
        final dieselQuantity = (testList[index]?.dieselQuantity ?? 0).toString();
        final totalPrice = (testList[index]?.totalPrice ?? 0).toStringAsFixed(2);
        final timestamp = testList[index]?.createdAt?.toString() ?? '';

        final hasFuelData = (testList[index]?.fuelQuantity ?? 0) > 0;
        final hasDieselData = (testList[index]?.dieselQuantity ?? 0) > 0;

        final orderStatus = testList[index]?.status ?? '';

        final timeAgo = DateHelper().formatTimeAgo(timestamp);
        return CusGestureDetector(
          onTap: () => onTapSupplierItem?.call(
            customerOrderId: testList[index]?.id ?? '',
            orderStatus: CustomerOrderCategoryX.orderStatusToEnum(orderStatus),
          ),
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
                    if (hasFuelData)
                      Text(
                        Strings.fuel + "(" + fuelQuantity + " " + "L" + ")",
                        style: TxtStyle.inter(fs: 11),
                      ).mT(5),
                    if (hasDieselData)
                      Text(
                        Strings.diesel + "(" + dieselQuantity + " " + "L" + ")",
                        style: TxtStyle.inter(fs: 11),
                      ).mT(5),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      makeCurrencyValue(totalPrice),
                      style: TxtStyle.inter(fs: 11, w: 700, color: c.primary),
                    ),

                    Text(timeAgo.date, style: TxtStyle.inter(fs: 10)).mT(5),
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

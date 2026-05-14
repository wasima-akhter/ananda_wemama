import '../../../../app/helper_widgets_export.dart';

class DragHandleForSheets extends StatelessWidget {
  const DragHandleForSheets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //---------------- DRAG HANDLE ----------------//
        Container(
          width: S.w * 0.3,
          height: 3,
          decoration: BoxDecoration(color: c.primary, borderRadius: 10.brdrRad),
        ),
        8.toHeight,
      ],
    );
  }
}

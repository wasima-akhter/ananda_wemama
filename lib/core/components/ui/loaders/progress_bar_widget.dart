import '../../../../app/helper_widgets_export.dart';

class ProgressBarWidget extends StatelessWidget {
  final String percent;
  final double? w; // optional width
  final double? barThickness;
  const ProgressBarWidget({super.key, required this.percent, this.w, this.barThickness});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = w ?? constraints.maxWidth; // use parent width if w is not provided
        return SizedBox(
          width: width,
          child: ClipRRect(
            borderRadius: 6.brdrRad,
            child: LinearProgressIndicator(
              value: (double.parse(percent) / 100).clamp(0.0, 1.0),
              minHeight: barThickness ?? 6,
              backgroundColor: Colors.grey.shade300,
              color: c.primary,
            ),
          ),
        );
      },
    );
  }
}

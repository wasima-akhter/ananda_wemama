import '../../../../app/helper_widgets_export.dart';

class RationaleDialog extends StatelessWidget {
  const RationaleDialog({super.key, required this.onAllowLocation});

  final VoidCallback onAllowLocation;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.my_location_rounded, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              Strings.allowLocationAccess.capEachWord(),
              style: TxtStyle.fs18.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.locationPermissionRationale, style: TxtStyle.norTxt),
          SizedBox(height: 16),
          _buildBullet(Icons.people_alt_rounded, Colors.purple, Strings.locationBenefitMatching),
          SizedBox(height: 8),
          _buildBullet(Icons.visibility_rounded, Colors.green, Strings.locationBenefitVisibility),
          SizedBox(height: 8),
          _buildBullet(Icons.lock_rounded, Colors.orange, Strings.locationBenefitPrivacy),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(Strings.notNow.capEachWord(), style: TextStyle(color: c.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: c.secondary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onAllowLocation,
          child: Text(Strings.allowLocation.capEachWord(), style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildBullet(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        SizedBox(width: 8),
        Expanded(child: Text(text, style: TxtStyle.norTxt.copyWith(fontSize: 12))),
      ],
    );
  }
}

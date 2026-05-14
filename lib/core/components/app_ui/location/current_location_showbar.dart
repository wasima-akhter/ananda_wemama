import '../../../../app/helper_widgets_export.dart';

class CurrentLocationShowbar extends StatelessWidget {
  final String selectedAddress;
  final double latitude;
  final double longitude;
  final String selectedCity;
  const CurrentLocationShowbar({
    super.key,
    required this.selectedAddress,
    required this.latitude,
    required this.longitude,
    required this.selectedCity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: c.primary, size: 20),
              const SizedBox(width: 8),
              Text(Strings.currentLocation, style: TxtStyle.inter(color: c.primary, w: 600)),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(Strings.location, selectedAddress),
          _buildInfoRow(Strings.latitude, latitude.toStringAsFixed(6)),
          _buildInfoRow(Strings.longitude, longitude.toStringAsFixed(6)),
          if (selectedCity.isNotEmpty) _buildInfoRow(Strings.city, selectedCity),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text("$label:", style: TxtStyle.inter(color: greyLoc, fs: 12, w: 500)),
          ),
          Expanded(
            child: Text(value, style: TxtStyle.inter(color: greyLoc, fs: 12)),
          ),
        ],
      ),
    );
  }
}

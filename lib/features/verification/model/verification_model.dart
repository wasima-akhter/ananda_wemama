enum VerificationStatus {
  notStarted,
  pending,
  processing,
  approved,
  declined,
  needsReview,
  expired;

  static VerificationStatus parse(String? s) {
    switch (s) {
      case 'pending':
        return pending;
      case 'processing':
        return processing;
      case 'approved':
        return approved;
      case 'declined':
        return declined;
      case 'needs_review':
        return needsReview;
      case 'expired':
        return expired;
      default:
        return notStarted;
    }
  }

  /// Stop fast polling
  bool get isFinal =>
      this == approved ||
      this == declined ||
      this == expired ||
      this == needsReview;
}

class VerificationSession {
  final String inquiryId;
  final String sessionToken;
  VerificationSession({required this.inquiryId, required this.sessionToken});

  factory VerificationSession.fromJson(dynamic j) => VerificationSession(
    inquiryId: j['inquiryId']?.toString() ?? '',
    sessionToken: j['sessionToken']?.toString() ?? '',
  );
}

class VerificationStatusData {
  final VerificationStatus status;
  final DateTime? completedAt;
  VerificationStatusData({required this.status, this.completedAt});

  factory VerificationStatusData.fromJson(dynamic j) => VerificationStatusData(
    status: VerificationStatus.parse(j['status']?.toString()),
    completedAt: j['completedAt'] != null
        ? DateTime.tryParse(j['completedAt'].toString())
        : null,
  );
}

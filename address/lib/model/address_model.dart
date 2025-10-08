

class Address {
  final int? id;
  final String addressLine1;
  final String? addressLine2;
  final int countryId;
  final int divisionId;
  final int districtId;
  final int policeStationId;

  Address({
    this.id,
    required this.addressLine1,
    this.addressLine2,
    required this.countryId,
    required this.divisionId,
    required this.districtId,
    required this.policeStationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'country': {'id': countryId},
      'division': {'id': divisionId},
      'district': {'id': districtId},
      'policeStation': {'id': policeStationId},
    };
  }
}

class UsbDevice {
  final int vendorId;
  final int productId;
  final String deviceName;
  final String manufacturerName;
  final String productName;
  final String version;

  UsbDevice({
    required this.vendorId,
    required this.productName,
    required this.productId,
    required this.deviceName,
    required this.manufacturerName,
    required this.version,
  });

  factory UsbDevice.fromMap(Map<String, dynamic> map) {
    return UsbDevice(
      vendorId: (map['vendorId'] as int?) ?? 0,
      productId: (map['productId'] as int?) ?? 0,
      deviceName: (map['deviceName'] as String?) ?? '',
      manufacturerName: (map['manufacturerName'] as String?) ?? '',
      productName: (map['productName'] as String?) ?? '',
      version: (map['version'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'vendorId': vendorId,
        'productId': productId,
        'deviceName': deviceName,
        'manufacturerName': manufacturerName,
        'productName': productName,
        'version': version,
      };
}

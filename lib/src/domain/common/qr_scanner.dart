import 'package:barcode_scan2/barcode_scan2.dart';

var isQrScannerShown = false;

class QRScanException implements Exception {
  QRScanException(this.message);

  String message;

  @override
  String toString() => message;
}

/// Shows the QR scanner to the user; this sets the future once the user either scans a QR code (we
/// return the string value), cancels (we return null), or an error occurs (we throw a
/// QRScanException).
Future<String?> presentQRScanner() async {
  isQrScannerShown = true;
  try {
    final result = await BarcodeScanner.scan();
    isQrScannerShown = false;
    if (result.type == ResultType.Error)
      throw QRScanException(result.rawContent);
    if (result.type == ResultType.Cancelled)
      return null;
    return result.rawContent;
  } catch (e) {
    isQrScannerShown = false;
    throw QRScanException(e.toString());
  }
}

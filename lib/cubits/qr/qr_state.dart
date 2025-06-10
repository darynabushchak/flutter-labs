abstract class QrState {}

class QrInitial extends QrState {}

class QrScanning extends QrState {}

class QrScanned extends QrState {
  final String rawValue;

  QrScanned(this.rawValue);
}

class QrError extends QrState {
  final String message;

  QrError(this.message);
}

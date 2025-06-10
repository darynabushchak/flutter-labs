abstract class SerialNumberState {}

class SerialNumberInitial extends SerialNumberState {}

class SerialNumberLoading extends SerialNumberState {}

class SerialNumberLoaded extends SerialNumberState {
  final String serialNumber;

  SerialNumberLoaded(this.serialNumber);
}

class SerialNumberError extends SerialNumberState {
  final String message;

  SerialNumberError(this.message);
}

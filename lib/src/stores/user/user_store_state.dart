
abstract class UserStoreState {}

class UserStoreStateInitial extends UserStoreState {}

class PinCodeSetSuccessfully extends UserStoreState {}

class PinCodeSetFailed extends UserStoreState {
  PinCodeSetFailed({required this.error});

  String error;
}

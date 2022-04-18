abstract class SendingState {}

class SendingStateInitial extends SendingState {}

class CreatingTransaction extends SendingState {}

class TransactionCreatedSuccessfully extends SendingState {}

class TransactionCommitting extends SendingState {}

class TransactionCommitted extends SendingState {}

class SendingFailed extends SendingState {
  SendingFailed({required this.error});
  
  String error;
}

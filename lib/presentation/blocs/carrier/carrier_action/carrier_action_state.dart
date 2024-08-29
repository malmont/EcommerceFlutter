
part of 'carrier_action_cubit.dart';



@immutable
abstract class CarrierActionState {}

class CarrierActionInitial extends CarrierActionState {}

class CarrierActionLoading extends CarrierActionState {}

class CarrierAddActionSuccess extends CarrierActionState {
  final Carrier carrier;
  CarrierAddActionSuccess(this.carrier);
}

class CarrierSelectActionSuccess extends CarrierActionState {
  final Carrier carrier;
  CarrierSelectActionSuccess(this.carrier);
}

class CarrierActionFail extends CarrierActionState {}

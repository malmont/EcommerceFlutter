part of 'carrier_fetch_cubit.dart';

@immutable

abstract class CarrierFetchState {
  final List<Carrier> carriers;
  final Carrier? selectedCarrier;
  const CarrierFetchState({required this.carriers, this.selectedCarrier});
}

class CarrierFetchInitial extends CarrierFetchState {
  const CarrierFetchInitial({
    required super.carriers,
    super.selectedCarrier,
  });
}

class CarrierFetchLoading extends CarrierFetchState {
  const CarrierFetchLoading({
    required super.carriers,
    super.selectedCarrier,
  });
}

class CarrierFetchSuccess extends CarrierFetchState {
  const CarrierFetchSuccess({
    required super.carriers,
    super.selectedCarrier,
  });
}

class CarrierFetchFail extends CarrierFetchState {
  const CarrierFetchFail({
    required super.carriers,
    super.selectedCarrier,
  });
}
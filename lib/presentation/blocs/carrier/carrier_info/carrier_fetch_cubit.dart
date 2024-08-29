import 'package:bloc/bloc.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/domain/entities/carrier.dart';
import 'package:eshop/domain/usecases/carrier/get_cached_carrier_usecase.dart';
import 'package:eshop/domain/usecases/carrier/get_remote_carrier_usecase.dart';
import 'package:eshop/domain/usecases/carrier/get_select_carrier_usecase.dart';
import 'package:flutter/foundation.dart';

part 'carrier_fetch_state.dart';

class CarrierFetchCubit extends Cubit<CarrierFetchState> {
  final GetRemoteCarrierUsecase _getRemoteCarrierUseCase;
  final GetCachedCarrierUsecase _getCachedCarrierUseCase;
  final GetSelectCarrierUsecase _getSelectedCarrierUseCase;

  CarrierFetchCubit(
    this._getRemoteCarrierUseCase,
    this._getCachedCarrierUseCase,
    this._getSelectedCarrierUseCase,
  ) : super(const CarrierFetchInitial(carriers: []));

  void fetchCarrier() async {
    try {
      emit(CarrierFetchLoading(
          carriers: const [], selectedCarrier: state.selectedCarrier));
      final cachedResult = await _getCachedCarrierUseCase(NoParams());
      cachedResult.fold(
        (failure) => (),
        (carrier) => emit(CarrierFetchSuccess(
          carriers: carrier,
          selectedCarrier: state.selectedCarrier,
        )),
      );
      final selectedCarrier = await _getSelectedCarrierUseCase(NoParams());
      selectedCarrier.fold(
        (failure) => (),
        (carrier) => emit(CarrierFetchSuccess(
          carriers: state.carriers,
          selectedCarrier: carrier,
        )),
      );
      final result = await _getRemoteCarrierUseCase(NoParams());
      result.fold(
        (failure) => emit(CarrierFetchFail(carriers: state.carriers)),
        (carrier) => emit(CarrierFetchSuccess(
            carriers: carrier, selectedCarrier: state.selectedCarrier)),
      );
      print("done");
    } catch (e) {
      print(e);
      emit(CarrierFetchFail(
          carriers: state.carriers, selectedCarrier: state.selectedCarrier));
    }
  }

  void addCarrier(Carrier carrier) {
    try {
      emit(CarrierFetchLoading(
          carriers: state.carriers, selectedCarrier: state.selectedCarrier));
      final value = state.carriers;
      value.add(carrier);
      emit(CarrierFetchSuccess(
          carriers: value, selectedCarrier: state.selectedCarrier));
    } catch (e) {
      emit(CarrierFetchFail(
          carriers: state.carriers, selectedCarrier: state.selectedCarrier));
    }
  }

  void selectCarrier(Carrier carrier) {
    try {
      emit(CarrierFetchLoading(
          carriers: state.carriers, selectedCarrier: state.selectedCarrier));
      emit(CarrierFetchSuccess(
          carriers: state.carriers, selectedCarrier: carrier));
    } catch (e) {
      emit(CarrierFetchFail(
          carriers: state.carriers, selectedCarrier: state.selectedCarrier));
    }
  }
}

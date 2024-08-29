


import 'package:bloc/bloc.dart';
import 'package:eshop/data/models/carrier_model.dart';
import 'package:eshop/domain/entities/carrier.dart';
import 'package:eshop/domain/usecases/carrier/add_carrier_usecase.dart';
import 'package:eshop/domain/usecases/carrier/select_carrier_usecase.dart';
import 'package:flutter/foundation.dart';

part 'carrier_action_state.dart';

///Use to preform carrier single actions without
///interruption to it's main view cubit's state[CarrierCubit]
class CarrierActionCubit extends Cubit<CarrierActionState> {
  // final AddCarrierUsecase _addCarrierUseCase;
  final SelectCarrierUsecase _selectCarrierUseCase;
  CarrierActionCubit(
    // this._addCarrierUseCase,
    this._selectCarrierUseCase,
  ) : super(CarrierActionInitial());

  // void addCarrier(CarrierModel params) async {
  //   try {
  //     emit(CarrierActionLoading());
  //     final result = await _addCarrierUseCase(params);
  //     result.fold(
  //       (failure) => emit(CarrierActionFail()),
  //       (carrier) => emit(CarrierAddActionSuccess(carrier)),
  //     );
  //   } catch (e) {
  //     emit(CarrierActionFail());
  //   }
  // }

  void selectCarrier(Carrier params) async {
    try {
      emit(CarrierActionLoading());
      final result = await _selectCarrierUseCase(params);
      result.fold(
        (failure) => emit(CarrierActionFail()),
        (carrier) => emit(CarrierSelectActionSuccess(carrier)),
      );
    } catch (e) {
      emit(CarrierActionFail());
    }
  }
}
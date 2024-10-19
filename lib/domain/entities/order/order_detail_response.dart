import 'package:equatable/equatable.dart';

class OrderDetailResponse extends Equatable {
  final int orderSource;
  final int paymentMethod;
  final int addressId;
  final int carrierId;
  final int typeOrder;
  final List<OrderItemDetail> items;

  const OrderDetailResponse({
    required this.orderSource,
    required this.paymentMethod,
    required this.addressId,
    required this.carrierId,
    required this.typeOrder,
    required this.items,
  });

  @override
  List<Object?> get props => [
        orderSource,
        paymentMethod,
        addressId,
        carrierId,
        typeOrder,
        items,
      ];
}

class OrderItemDetail extends Equatable {
  final int productVariantId;
  final int quantity;

  const OrderItemDetail({
    required this.productVariantId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productVariantId, quantity];
}

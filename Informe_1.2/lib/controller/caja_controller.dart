import '../model/caja_model.dart';

class CajaController {
  /// Valida y crea un [BilleteMoneda].
  BilleteMoneda? agregarItem(String sDenominacion, String sCantidad) {
    final denom = double.tryParse(sDenominacion);
    final cant = int.tryParse(sCantidad);
    if (denom == null || denom <= 0) return null;
    if (cant == null || cant <= 0) return null;
    return BilleteMoneda(denominacion: denom, cantidad: cant);
  }

  double calcularTotal(List<BilleteMoneda> items) {
    return CajaModel.calcularTotal(items);
  }
}

import '../model/venta_model.dart';

class VentaController {
  /// Devuelve null si la lista de productos está vacía.
  FacturaResultado? calcular(List<ProductoItem> productos, String sSueldoBase) {
    if (productos.isEmpty) return null;
    final sueldoBase = double.tryParse(sSueldoBase) ?? 0.0;
    return FacturaResultado.calcular(productos, sueldoBase);
  }
}

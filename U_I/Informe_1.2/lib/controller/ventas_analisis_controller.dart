import '../model/ventas_analisis_model.dart';

class VentasAnalisisController {
  /// Valida y convierte [sVenta] a [VentaItem]. Devuelve null si inválido.
  VentaItem? parsearVenta(String sVenta) {
    final v = double.tryParse(sVenta.trim());
    if (v == null || v <= 0) return null;
    return VentaItem(monto: v);
  }

  VentasAnalisisResultado analizar(List<VentaItem> ventas) {
    return VentasAnalisisResultado.calcular(ventas);
  }
}

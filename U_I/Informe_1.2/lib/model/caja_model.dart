class BilleteMoneda {
  final double denominacion;
  final int cantidad;

  const BilleteMoneda({required this.denominacion, required this.cantidad});

  double get subtotal => denominacion * cantidad;
}

class CajaModel {
  static double calcularTotal(List<BilleteMoneda> items) {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }
}

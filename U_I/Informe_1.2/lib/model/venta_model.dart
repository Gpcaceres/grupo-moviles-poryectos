class ProductoItem {
  final String nombre;
  final double precio;
  final int cantidad;

  ProductoItem({
    required this.nombre,
    required this.precio,
    required this.cantidad,
  });

  double get subtotal => precio * cantidad;
}

class FacturaResultado {
  final List<ProductoItem> productos;
  final double sueldoBase;
  final double subtotalProductos;
  final double iva;
  final double subtotalConIva;
  final bool tieneDescuento;
  final double descuento;
  final double totalFinal;
  final double comision;
  final double sueldoTotal;

  FacturaResultado({
    required this.productos,
    required this.sueldoBase,
    required this.subtotalProductos,
    required this.iva,
    required this.subtotalConIva,
    required this.tieneDescuento,
    required this.descuento,
    required this.totalFinal,
    required this.comision,
    required this.sueldoTotal,
  });

  static FacturaResultado calcular(
    List<ProductoItem> productos,
    double sueldoBase,
  ) {
    final subtotal = productos.fold<double>(0, (sum, p) => sum + p.subtotal);
    final iva = subtotal * 0.15;
    final subtotalConIva = subtotal + iva;
    final tieneDescuento = subtotalConIva > 2000;
    final descuento = tieneDescuento ? subtotalConIva * 0.20 : 0.0;
    final totalFinal = subtotalConIva - descuento;
    // El vendedor gana 5% de comisión sobre el subtotal de la venta
    final comision = subtotal * 0.05;
    final sueldoTotal = sueldoBase + comision;

    return FacturaResultado(
      productos: productos,
      sueldoBase: sueldoBase,
      subtotalProductos: subtotal,
      iva: iva,
      subtotalConIva: subtotalConIva,
      tieneDescuento: tieneDescuento,
      descuento: descuento,
      totalFinal: totalFinal,
      comision: comision,
      sueldoTotal: sueldoTotal,
    );
  }
}

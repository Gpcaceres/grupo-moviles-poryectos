class VentaItem {
  final double monto;

  const VentaItem({required this.monto});

  /// Categoría: 0 = ≤10000, 1 = >10000 y <20000, 2 = ≥20000
  int get categoria {
    if (monto <= 10000) return 0;
    if (monto < 20000) return 1;
    return 2;
  }
}

class CategoriaResumen {
  final String nombre;
  final int cantidad;
  final double total;

  const CategoriaResumen({
    required this.nombre,
    required this.cantidad,
    required this.total,
  });
}

class VentasAnalisisResultado {
  final List<VentaItem> ventas;
  final List<CategoriaResumen> categorias;
  final double totalGlobal;

  const VentasAnalisisResultado({
    required this.ventas,
    required this.categorias,
    required this.totalGlobal,
  });

  static const List<String> _nombres = [
    '≤ \$10,000',
    '> \$10,000 y < \$20,000',
    '≥ \$20,000',
  ];

  static VentasAnalisisResultado calcular(List<VentaItem> ventas) {
    final counts = [0, 0, 0];
    final totals = [0.0, 0.0, 0.0];

    for (final v in ventas) {
      counts[v.categoria]++;
      totals[v.categoria] += v.monto;
    }

    final categorias = List.generate(
      3,
      (i) => CategoriaResumen(
        nombre: _nombres[i],
        cantidad: counts[i],
        total: totals[i],
      ),
    );

    final totalGlobal = ventas.fold<double>(0, (s, v) => s + v.monto);

    return VentasAnalisisResultado(
      ventas: ventas,
      categorias: categorias,
      totalGlobal: totalGlobal,
    );
  }
}

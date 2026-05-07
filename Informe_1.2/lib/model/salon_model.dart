class SalonResultado {
  final int numero;
  final List<double> edades;
  final double promedio;

  const SalonResultado({
    required this.numero,
    required this.edades,
    required this.promedio,
  });
}

class SalonModel {
  static double calcularPromedio(List<double> edades) {
    if (edades.isEmpty) return 0;
    return edades.reduce((a, b) => a + b) / edades.length;
  }

  static List<SalonResultado> calcular(List<List<double>> salones) {
    return List.generate(salones.length, (i) {
      final edades = salones[i];
      return SalonResultado(
        numero: i + 1,
        edades: edades,
        promedio: calcularPromedio(edades),
      );
    });
  }

  static double promedioEscuela(List<SalonResultado> resultados) {
    final todasEdades = resultados.expand((s) => s.edades).toList();
    return calcularPromedio(todasEdades);
  }
}

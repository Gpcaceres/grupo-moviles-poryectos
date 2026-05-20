import '../model/salon_model.dart';

class SalonController {
  /// Recibe [numSalones] y una lista de strings (edades separadas por comas).
  /// Devuelve null si algún dato es inválido.
  List<SalonResultado>? calcular(int numSalones, List<String> edadesTextos) {
    if (numSalones <= 0 || edadesTextos.length != numSalones) return null;

    final salones = <List<double>>[];
    for (final texto in edadesTextos) {
      final partes = texto.split(',').map((s) => s.trim()).toList();
      final edades = <double>[];
      for (final p in partes) {
        final v = double.tryParse(p);
        if (v == null || v <= 0) return null;
        edades.add(v);
      }
      if (edades.isEmpty) return null;
      salones.add(edades);
    }
    return SalonModel.calcular(salones);
  }
}

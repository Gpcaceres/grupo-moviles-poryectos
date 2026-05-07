class BancoAnioResultado {
  final int anio;
  final double saldoFinal;

  const BancoAnioResultado({required this.anio, required this.saldoFinal});
}

class BancoModel {
  /// Calcula el saldo al final de cada año para N años.
  /// Se deposita [depositoMensual] cada mes con una tasa anual del 10%.
  static List<BancoAnioResultado> calcular(double depositoMensual, int nAnios) {
    const tasaMensual = 0.10 / 12;
    final resultados = <BancoAnioResultado>[];
    double saldo = 0;

    for (int anio = 1; anio <= nAnios; anio++) {
      for (int mes = 1; mes <= 12; mes++) {
        saldo += depositoMensual;
        saldo += saldo * tasaMensual;
      }
      resultados.add(BancoAnioResultado(anio: anio, saldoFinal: saldo));
    }
    return resultados;
  }
}

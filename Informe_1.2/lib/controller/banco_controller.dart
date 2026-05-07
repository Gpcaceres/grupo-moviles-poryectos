import '../model/banco_model.dart';

class BancoController {
  /// Devuelve lista de resultados por año o null si los datos son inválidos.
  List<BancoAnioResultado>? calcular(String sDeposito, String sAnios) {
    final deposito = double.tryParse(sDeposito);
    final anios = int.tryParse(sAnios);
    if (deposito == null || deposito <= 0) return null;
    if (anios == null || anios <= 0 || anios > 100) return null;
    return BancoModel.calcular(deposito, anios);
  }
}

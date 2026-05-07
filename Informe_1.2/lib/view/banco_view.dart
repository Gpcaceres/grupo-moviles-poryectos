import 'package:flutter/material.dart';
import '../controller/banco_controller.dart';
import '../model/banco_model.dart';

// ═══════════════════════════════════════════════════════════════
//  ÁTOMOS
// ═══════════════════════════════════════════════════════════════

class _AtomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;

  const _AtomInput({required this.label, required this.controller, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  MOLÉCULAS
// ═══════════════════════════════════════════════════════════════

class _MolBancoForm extends StatelessWidget {
  final TextEditingController depositoCtrl;
  final TextEditingController aniosCtrl;
  final VoidCallback onCalcular;

  const _MolBancoForm({
    required this.depositoCtrl,
    required this.aniosCtrl,
    required this.onCalcular,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AtomInput(
          label: 'Depósito mensual (\$)',
          controller: depositoCtrl,
          hint: 'Ej: 500',
        ),
        const SizedBox(height: 10),
        _AtomInput(
          label: 'Número de años (N)',
          controller: aniosCtrl,
          hint: 'Ej: 5',
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: onCalcular,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Calcular Inversión',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

/// Fila de resultado por año
class _MolAnioRow extends StatelessWidget {
  final BancoAnioResultado dato;

  const _MolAnioRow({required this.dato});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: Colors.indigo.shade100,
        child: Text(
          '${dato.anio}',
          style: TextStyle(
            color: Colors.indigo.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text('Año ${dato.anio}'),
      trailing: Text(
        '\$${dato.saldoFinal.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ORGANISMO
// ═══════════════════════════════════════════════════════════════

class _OrgBancoCard extends StatefulWidget {
  const _OrgBancoCard();

  @override
  State<_OrgBancoCard> createState() => _OrgBancoCardState();
}

class _OrgBancoCardState extends State<_OrgBancoCard> {
  final _depositoCtrl = TextEditingController();
  final _aniosCtrl = TextEditingController();
  final _controller = BancoController();

  List<BancoAnioResultado>? _resultados;
  String? _error;

  void _calcular() {
    final res = _controller.calcular(_depositoCtrl.text, _aniosCtrl.text);
    setState(() {
      if (res == null) {
        _error =
            'Ingrese valores válidos. El depósito debe ser > 0 y los años entre 1 y 100.';
        _resultados = null;
      } else {
        _error = null;
        _resultados = res;
      }
    });
  }

  @override
  void dispose() {
    _depositoCtrl.dispose();
    _aniosCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cuenta de Ahorros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Depósito mensual fijo · Interés anual 10%',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 14),
                _MolBancoForm(
                  depositoCtrl: _depositoCtrl,
                  aniosCtrl: _aniosCtrl,
                  onCalcular: _calcular,
                ),
              ],
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.red.shade50,
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        ],
        if (_resultados != null) ...[
          const SizedBox(height: 14),
          Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                  child: Row(
                    children: [
                      Icon(Icons.savings, color: Colors.indigo.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Inversión Final por Año',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ..._resultados!.map((d) => _MolAnioRow(dato: d)),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total acumulado:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${_resultados!.last.saldoFinal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.indigo.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PÁGINA
// ═══════════════════════════════════════════════════════════════

class BancoPage extends StatelessWidget {
  const BancoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problema 4.9 — Cuenta de Ahorros'),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _OrgBancoCard(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controller/salon_controller.dart';
import '../model/salon_model.dart';

// ═══════════════════════════════════════════════════════════════
//  ÁTOMOS
// ═══════════════════════════════════════════════════════════════

class _AtomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? hint;

  const _AtomInput({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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

class _MolSalonInput extends StatelessWidget {
  final int index;
  final TextEditingController controller;

  const _MolSalonInput({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _AtomInput(
      label: 'Salón ${index + 1} — edades',
      controller: controller,
      hint: 'Ej: 15, 16, 14, 17',
    );
  }
}

class _MolSalonResultRow extends StatelessWidget {
  final SalonResultado resultado;

  const _MolSalonResultRow({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: Colors.teal.shade100,
        child: Text(
          '${resultado.numero}',
          style: TextStyle(
            color: Colors.teal.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text('Salón ${resultado.numero}'),
      subtitle: Text('${resultado.edades.length} estudiantes'),
      trailing: Text(
        'Prom: ${resultado.promedio.toStringAsFixed(2)} años',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ORGANISMO
// ═══════════════════════════════════════════════════════════════

class _OrgSalonCard extends StatefulWidget {
  const _OrgSalonCard();

  @override
  State<_OrgSalonCard> createState() => _OrgSalonCardState();
}

class _OrgSalonCardState extends State<_OrgSalonCard> {
  final _numSalonesCtrl = TextEditingController();
  List<TextEditingController> _salonCtrls = [];
  int _numSalones = 0;

  final _controller = SalonController();
  List<SalonResultado>? _resultados;
  double? _promedioEscuela;
  String? _error;

  void _generarCampos() {
    final n = int.tryParse(_numSalonesCtrl.text);
    if (n == null || n <= 0 || n > 20) {
      setState(() => _error = 'Ingrese un número válido de salones (1-20).');
      return;
    }
    for (final c in _salonCtrls) {
      c.dispose();
    }
    setState(() {
      _error = null;
      _numSalones = n;
      _salonCtrls = List.generate(n, (_) => TextEditingController());
      _resultados = null;
      _promedioEscuela = null;
    });
  }

  void _calcular() {
    if (_numSalones == 0 || _salonCtrls.isEmpty) {
      setState(() => _error = 'Primero genere los campos de los salones.');
      return;
    }
    final textos = _salonCtrls.map((c) => c.text.trim()).toList();
    final res = _controller.calcular(_numSalones, textos);
    if (res == null) {
      setState(() {
        _error =
            'Verifique que todas las edades sean números positivos separados por comas.';
        _resultados = null;
      });
    } else {
      setState(() {
        _error = null;
        _resultados = res;
        _promedioEscuela = SalonModel.promedioEscuela(res);
      });
    }
  }

  @override
  void dispose() {
    _numSalonesCtrl.dispose();
    for (final c in _salonCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Paso 1: ingresar M salones
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paso 1 — Número de Salones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _AtomInput(
                        label: 'Número de salones (M)',
                        controller: _numSalonesCtrl,
                        keyboardType: TextInputType.number,
                        hint: 'Ej: 3',
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _generarCampos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Generar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Paso 2: ingresar edades por salón
        if (_numSalones > 0) ...[
          const SizedBox(height: 12),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paso 2 — Edades por Salón',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ingrese las edades separadas por comas.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    _numSalones,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _MolSalonInput(
                        index: i,
                        controller: _salonCtrls[i],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _calcular,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Calcular Promedios',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        if (_error != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.red.shade50,
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        ],

        // Resultados
        if (_resultados != null) ...[
          const SizedBox(height: 14),
          Card(
            elevation: 3,
            color: Colors.teal.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                  child: Row(
                    children: [
                      Icon(Icons.school, color: Colors.teal.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Resultados por Salón',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ..._resultados!.map((r) => _MolSalonResultRow(resultado: r)),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Promedio de la Escuela:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_promedioEscuela!.toStringAsFixed(2)} años',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal.shade800,
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

class SalonPage extends StatelessWidget {
  const SalonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problema 4.10 — Promedios de Salones'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _OrgSalonCard(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controller/ventas_analisis_controller.dart';
import '../model/ventas_analisis_model.dart';

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

class _MolVentaIngreso extends StatelessWidget {
  final TextEditingController ctrl;
  final VoidCallback onAgregar;

  const _MolVentaIngreso({required this.ctrl, required this.onAgregar});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AtomInput(
            label: 'Monto de la venta (\$)',
            controller: ctrl,
            hint: 'Ej: 15000',
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: onAgregar,
          icon: const Icon(Icons.add),
          label: const Text('Agregar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade700,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _MolVentaTile extends StatelessWidget {
  final int index;
  final VentaItem venta;
  final VoidCallback onEliminar;

  static const _colores = [Colors.green, Colors.orange, Colors.blue];
  static const _iconos = [
    Icons.arrow_downward,
    Icons.trending_flat,
    Icons.arrow_upward,
  ];

  const _MolVentaTile({
    required this.index,
    required this.venta,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: _colores[venta.categoria].withValues(alpha: 0.15),
        child: Icon(
          _iconos[venta.categoria],
          color: _colores[venta.categoria],
          size: 18,
        ),
      ),
      title: Text('Venta ${index + 1}: \$${venta.monto.toStringAsFixed(2)}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: onEliminar,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}

class _MolCategoriaCard extends StatelessWidget {
  final CategoriaResumen resumen;
  final Color color;

  const _MolCategoriaCard({required this.resumen, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.08),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resumen.nombre,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                  Text('${resumen.cantidad} venta(s)'),
                ],
              ),
            ),
            Text(
              '\$${resumen.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ORGANISMO
// ═══════════════════════════════════════════════════════════════

class _OrgVentasCard extends StatefulWidget {
  const _OrgVentasCard();

  @override
  State<_OrgVentasCard> createState() => _OrgVentasCardState();
}

class _OrgVentasCardState extends State<_OrgVentasCard> {
  final _montoCtrl = TextEditingController();
  final _controller = VentasAnalisisController();
  final List<VentaItem> _ventas = [];
  String? _error;
  VentasAnalisisResultado? _resultado;

  static const _colores = [Colors.green, Colors.orange, Colors.blue];

  void _agregar() {
    final item = _controller.parsearVenta(_montoCtrl.text);
    if (item == null) {
      setState(() => _error = 'Ingrese un monto válido mayor a 0.');
      return;
    }
    setState(() {
      _error = null;
      _ventas.add(item);
      _montoCtrl.clear();
      _resultado = null;
    });
  }

  void _calcular() {
    if (_ventas.isEmpty) {
      setState(() => _error = 'Agregue al menos una venta.');
      return;
    }
    setState(() {
      _error = null;
      _resultado = _controller.analizar(_ventas);
    });
  }

  void _eliminar(int index) {
    setState(() {
      _ventas.removeAt(index);
      _resultado = null;
    });
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Formulario ingreso ventas
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registrar Ventas',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ingrese cada venta y presione Agregar.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 12),
                _MolVentaIngreso(ctrl: _montoCtrl, onAgregar: _agregar),
              ],
            ),
          ),
        ),

        if (_error != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.red.shade50,
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        ],

        // Lista ventas ingresadas
        if (_ventas.isNotEmpty) ...[
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_ventas.length} venta(s) registrada(s)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: _calcular,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                        ),
                        child: const Text('Analizar'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ..._ventas.asMap().entries.map(
                  (e) => _MolVentaTile(
                    index: e.key,
                    venta: e.value,
                    onEliminar: () => _eliminar(e.key),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Resultados del análisis
        if (_resultado != null) ...[
          const SizedBox(height: 14),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: Colors.deepPurple.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Análisis de Ventas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._resultado!.categorias.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _MolCategoriaCard(
                        resumen: e.value,
                        color: _colores[e.key],
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MONTO GLOBAL:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_resultado!.totalGlobal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

class VentasAnalisisPage extends StatelessWidget {
  const VentasAnalisisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problema 4.13 — Análisis de Ventas'),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _OrgVentasCard(),
      ),
    );
  }
}

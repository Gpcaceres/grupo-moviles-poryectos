import 'package:flutter/material.dart';
import '../controller/caja_controller.dart';
import '../model/caja_model.dart';

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

class _MolItemForm extends StatelessWidget {
  final TextEditingController denomCtrl;
  final TextEditingController cantCtrl;
  final VoidCallback onAgregar;

  const _MolItemForm({
    required this.denomCtrl,
    required this.cantCtrl,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _AtomInput(
                label: 'Valor (\$)',
                controller: denomCtrl,
                hint: 'Ej: 100',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AtomInput(
                label: 'Cantidad',
                controller: cantCtrl,
                hint: 'Ej: 5',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: onAgregar,
            icon: const Icon(Icons.add),
            label: const Text('Agregar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _MolItemTile extends StatelessWidget {
  final BilleteMoneda item;
  final VoidCallback onEliminar;

  const _MolItemTile({required this.item, required this.onEliminar});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.monetization_on_outlined),
      title: Text(
        '\$${item.denominacion.toStringAsFixed(2)} x ${item.cantidad}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$${item.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onEliminar,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ORGANISMO
// ═══════════════════════════════════════════════════════════════

class _OrgCajaCard extends StatefulWidget {
  const _OrgCajaCard();

  @override
  State<_OrgCajaCard> createState() => _OrgCajaCardState();
}

class _OrgCajaCardState extends State<_OrgCajaCard> {
  final _denomCtrl = TextEditingController();
  final _cantCtrl = TextEditingController();
  final _controller = CajaController();

  final List<BilleteMoneda> _items = [];
  String? _error;

  void _agregar() {
    final item = _controller.agregarItem(_denomCtrl.text, _cantCtrl.text);
    if (item == null) {
      setState(() => _error = 'Ingrese un valor y cantidad válidos (> 0).');
      return;
    }
    setState(() {
      _error = null;
      _items.add(item);
      _denomCtrl.clear();
      _cantCtrl.clear();
    });
  }

  void _eliminar(int index) {
    setState(() => _items.removeAt(index));
  }

  @override
  void dispose() {
    _denomCtrl.dispose();
    _cantCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _controller.calcularTotal(_items);

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
                  'Ingreso de Billetes / Monedas',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _MolItemForm(
                  denomCtrl: _denomCtrl,
                  cantCtrl: _cantCtrl,
                  onAgregar: _agregar,
                ),
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
        if (_items.isNotEmpty) ...[
          const SizedBox(height: 14),
          Card(
            elevation: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                  child: Row(
                    children: [
                      Icon(Icons.point_of_sale, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Detalle de la Caja',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ..._items.asMap().entries.map(
                  (e) => _MolItemTile(
                    item: e.value,
                    onEliminar: () => _eliminar(e.key),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL CAJA:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
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

class CajaPage extends StatelessWidget {
  const CajaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problema 4.12 — Caja Registradora'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _OrgCajaCard(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controller/venta_controller.dart';
import '../model/venta_model.dart';

// ═══════════════════════════════════════════════════════════════
//  ÁTOMOS
// ═══════════════════════════════════════════════════════════════

class _AtomLabel extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight weight;
  final Color? color;

  const _AtomLabel(
    this.text, {
    this.fontSize = 16,
    this.weight = FontWeight.normal,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: weight, color: color),
    );
  }
}

class _AtomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _AtomInput({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
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

class _AtomDivider extends StatelessWidget {
  const _AtomDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(color: Colors.blueGrey, thickness: 1);
}

// ═══════════════════════════════════════════════════════════════
//  MOLÉCULAS
// ═══════════════════════════════════════════════════════════════

/// Fila de ingreso de un producto (nombre, precio, cantidad)
class _MolProductoForm extends StatelessWidget {
  final TextEditingController nombreCtrl;
  final TextEditingController precioCtrl;
  final TextEditingController cantCtrl;
  final VoidCallback onAdd;

  const _MolProductoForm({
    required this.nombreCtrl,
    required this.precioCtrl,
    required this.cantCtrl,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AtomInput(label: 'Nombre del producto', controller: nombreCtrl),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _AtomInput(
                label: 'Precio (\$)',
                controller: precioCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _AtomInput(
                label: 'Cantidad',
                controller: cantCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Producto'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Fila de un producto en la lista
class _MolProductoTile extends StatelessWidget {
  final ProductoItem item;
  final VoidCallback onDelete;

  const _MolProductoTile({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(item.nombre),
      subtitle: Text('\$${item.precio.toStringAsFixed(2)} × ${item.cantidad}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$${item.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

/// Fila de resultado (etiqueta + valor)
class _MolResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _MolResultRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final fw = isTotal ? FontWeight.bold : FontWeight.normal;
    final fs = isTotal ? 16.0 : 14.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: fs, fontWeight: fw),
          ),
          Text(
            value,
            style: TextStyle(fontSize: fs, fontWeight: fw, color: valueColor),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ORGANISMOS
// ═══════════════════════════════════════════════════════════════

class _OrgVentaForm extends StatefulWidget {
  const _OrgVentaForm();

  @override
  State<_OrgVentaForm> createState() => _OrgVentaFormState();
}

class _OrgVentaFormState extends State<_OrgVentaForm> {
  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _cantCtrl = TextEditingController();
  final _sueldoBaseCtrl = TextEditingController();
  final _controller = VentaController();

  final List<ProductoItem> _productos = [];
  FacturaResultado? _resultado;
  String? _error;

  void _agregarProducto() {
    final nombre = _nombreCtrl.text.trim();
    final precio = double.tryParse(_precioCtrl.text);
    final cantidad = int.tryParse(_cantCtrl.text);

    if (nombre.isEmpty || precio == null || cantidad == null || cantidad <= 0) {
      setState(
        () => _error = 'Complete correctamente todos los campos del producto.',
      );
      return;
    }
    setState(() {
      _error = null;
      _productos.add(
        ProductoItem(nombre: nombre, precio: precio, cantidad: cantidad),
      );
      _nombreCtrl.clear();
      _precioCtrl.clear();
      _cantCtrl.clear();
      _resultado = null;
    });
  }

  void _calcular() {
    if (_productos.isEmpty) {
      setState(() => _error = 'Agregue al menos un producto.');
      return;
    }
    final res = _controller.calcular(_productos, _sueldoBaseCtrl.text);
    setState(() {
      _error = null;
      _resultado = res;
    });
  }

  void _limpiar() {
    setState(() {
      _productos.clear();
      _resultado = null;
      _error = null;
      _sueldoBaseCtrl.clear();
    });
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _cantCtrl.dispose();
    _sueldoBaseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sueldo base del vendedor
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AtomLabel(
                    'Datos del Vendedor',
                    fontSize: 16,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  _AtomInput(
                    label: 'Sueldo base del vendedor (\$)',
                    controller: _sueldoBaseCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Formulario de productos
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AtomLabel(
                    'Agregar Producto',
                    fontSize: 16,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 10),
                  _MolProductoForm(
                    nombreCtrl: _nombreCtrl,
                    precioCtrl: _precioCtrl,
                    cantCtrl: _cantCtrl,
                    onAdd: _agregarProducto,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Lista de productos
          if (_productos.isNotEmpty) ...[
            Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                    child: _AtomLabel(
                      'Productos (${_productos.length})',
                      fontSize: 15,
                      weight: FontWeight.bold,
                    ),
                  ),
                  const _AtomDivider(),
                  ...List.generate(
                    _productos.length,
                    (i) => _MolProductoTile(
                      item: _productos[i],
                      onDelete: () => setState(() => _productos.removeAt(i)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (_error != null)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.red.shade50,
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _calcular,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                  ),
                  child: const Text(
                    'Generar Factura',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(onPressed: _limpiar, child: const Text('Limpiar')),
            ],
          ),

          // Resultado: Factura + Sueldo
          if (_resultado != null) ...[
            const SizedBox(height: 16),
            _FacturaCard(resultado: _resultado!),
            const SizedBox(height: 12),
            _SueldoCard(resultado: _resultado!),
          ],
        ],
      ),
    );
  }
}

// ─── Factura ─────────────────────────────────────────────────────────────────
class _FacturaCard extends StatelessWidget {
  final FacturaResultado resultado;
  const _FacturaCard({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _AtomLabel(
                '🧾 FACTURA DE VENTA',
                fontSize: 18,
                weight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 10),
            const _AtomDivider(),
            ...resultado.productos.map(
              (p) => _MolResultRow(
                label: '${p.nombre} (x${p.cantidad})',
                value: '\$${p.subtotal.toStringAsFixed(2)}',
              ),
            ),
            const _AtomDivider(),
            _MolResultRow(
              label: 'Subtotal',
              value: '\$${resultado.subtotalProductos.toStringAsFixed(2)}',
            ),
            _MolResultRow(
              label: 'IVA (15%)',
              value: '\$${resultado.iva.toStringAsFixed(2)}',
              valueColor: Colors.orange.shade700,
            ),
            _MolResultRow(
              label: 'Subtotal + IVA',
              value: '\$${resultado.subtotalConIva.toStringAsFixed(2)}',
            ),
            if (resultado.tieneDescuento)
              _MolResultRow(
                label: 'Descuento (20% — compra > \$2000)',
                value: '- \$${resultado.descuento.toStringAsFixed(2)}',
                valueColor: Colors.green.shade700,
              ),
            const _AtomDivider(),
            _MolResultRow(
              label: 'TOTAL A PAGAR',
              value: '\$${resultado.totalFinal.toStringAsFixed(2)}',
              isTotal: true,
              valueColor: Colors.blue.shade900,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sueldo Vendedor ──────────────────────────────────────────────────────────
class _SueldoCard extends StatelessWidget {
  final FacturaResultado resultado;
  const _SueldoCard({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _AtomLabel(
                '💼 SUELDO DEL VENDEDOR',
                fontSize: 18,
                weight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 10),
            const _AtomDivider(),
            _MolResultRow(
              label: 'Sueldo base',
              value: '\$${resultado.sueldoBase.toStringAsFixed(2)}',
            ),
            _MolResultRow(
              label: 'Comisión (5% del subtotal)',
              value: '\$${resultado.comision.toStringAsFixed(2)}',
              valueColor: Colors.green.shade700,
            ),
            const _AtomDivider(),
            _MolResultRow(
              label: 'SUELDO TOTAL',
              value: '\$${resultado.sueldoTotal.toStringAsFixed(2)}',
              isTotal: true,
              valueColor: Colors.green.shade900,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PÁGINA
// ═══════════════════════════════════════════════════════════════
class VentaPage extends StatelessWidget {
  const VentaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problema 1 — Venta / Factura'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: const _OrgVentaForm(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bom_provider.dart';
import '../../models/bill_of_materials.dart';

class CreateBomScreen extends StatefulWidget {
  final String projectId;
  final String userId;

  const CreateBomScreen({
    Key? key,
    required this.projectId,
    required this.userId,
  }) : super(key: key);

  @override
  State<CreateBomScreen> createState() => _CreateBomScreenState();
}

class _CreateBomScreenState extends State<CreateBomScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<BomMaterial> _materials = [];
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _unitPriceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _addMaterial() {
    if (_formKey.currentState!.validate()) {
      final quantity = double.parse(_quantityController.text);
      final unitPrice = double.parse(_unitPriceController.text);
      final totalCost = quantity * unitPrice;

      setState(() {
        _materials.add(
          BomMaterial(
            materialId: DateTime.now().millisecondsSinceEpoch.toString(),
            name: _nameController.text,
            quantity: quantity,
            unit: _unitController.text,
            currentStock: quantity,
            initialQuantity: quantity,
            unitPrice: unitPrice,
            totalCost: totalCost,
          ),
        );
      });

      // Clear form
      _nameController.clear();
      _quantityController.clear();
      _unitController.clear();
      _unitPriceController.clear();
    }
  }

  void _removeMaterial(int index) {
    setState(() {
      _materials.removeAt(index);
    });
  }

  Future<void> _createBom() async {
    if (_materials.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one material'),
        ),
      );
      return;
    }

    await context.read<BomProvider>().createBom(
          widget.projectId,
          widget.userId,
          _materials,
        );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Bill of Materials'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Material Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a material name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a quantity';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _unitController,
                            decoration: const InputDecoration(
                              labelText: 'Unit',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a unit';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _unitPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Price',
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a unit price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _addMaterial,
                      child: const Text('Add Material'),
                    ),
                    const SizedBox(height: 24),
                    if (_materials.isNotEmpty) ...[
                      const Text(
                        'Added Materials:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _materials.length,
                        itemBuilder: (context, index) {
                          final material = _materials[index];
                          return Card(
                            child: ListTile(
                              title: Text(material.name),
                              subtitle: Text(
                                '${material.quantity} ${material.unit} - \$${material.totalCost.toStringAsFixed(2)}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeMaterial(index),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _createBom,
              child: const Text('Create Bill of Materials'),
            ),
          ),
        ],
      ),
    );
  }
}

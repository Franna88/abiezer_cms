import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../placeholder_screen.dart';

class PurchasesContent extends StatelessWidget {
  final ProjectModel? selectedProject;

  const PurchasesContent({Key? key, required this.selectedProject})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectedProject == null
        ? const Center(child: Text('Please select a project'))
        : PlaceholderScreen(
          title: 'Purchases',
          icon: Icons.shopping_cart_outlined,
        );
  }
}

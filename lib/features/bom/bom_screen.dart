import 'package:flutter/material.dart';
import '../../core/models/bill_of_materials_model.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/constants.dart';
import '../../core/utilities/utilities.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/responsive_layout.dart';
import '../../widgets/common/section_header.dart';
import 'pages/bom_tabs_page.dart';

class BomScreen extends StatefulWidget {
  final String? projectId;
  final UserModel currentUser;

  const BomScreen({super.key, this.projectId, required this.currentUser});

  @override
  State<BomScreen> createState() => _BomScreenState();
}

class _BomScreenState extends State<BomScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : BomTabsPage(projectId: widget.projectId),
    );
  }
}

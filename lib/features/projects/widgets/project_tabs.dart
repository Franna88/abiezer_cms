import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';

class ProjectTabs extends StatelessWidget {
  final TabController tabController;
  final int currentIndex;

  const ProjectTabs({
    super.key,
    required this.tabController,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        isScrollable: Utils.isMobile(context),
        tabs: const [
          Tab(
            text: 'Overview',
            icon: Icon(Icons.dashboard_outlined),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'Bill of Materials',
            icon: Icon(Icons.inventory_2_outlined),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'Purchases',
            icon: Icon(Icons.shopping_cart_outlined),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'History',
            icon: Icon(Icons.history_outlined),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
        ],
      ),
    );
  }
}

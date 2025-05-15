import 'package:flutter/material.dart';
import '../../core/utilities/utilities.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Utils.isDesktop(context)) {
          return desktop ?? tablet ?? mobile;
        } else if (Utils.isTablet(context)) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  ResponsiveValue({required this.mobile, this.tablet, this.desktop});

  T get(BuildContext context) {
    if (Utils.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (Utils.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry padding;
  final ResponsiveValue<int> crossAxisCount;
  final double childAspectRatio;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollController? controller;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.padding = EdgeInsets.zero,
    required this.crossAxisCount,
    this.childAspectRatio = 1.0,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount.get(context),
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
      physics: physics,
      shrinkWrap: shrinkWrap,
      controller: controller,
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final ResponsiveValue<double>? maxWidth;
  final Alignment alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.color,
    this.width,
    this.height,
    this.decoration,
    this.maxWidth,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      color: color,
      width: width,
      height: height,
      decoration: decoration,
      constraints:
          maxWidth != null
              ? BoxConstraints(maxWidth: maxWidth!.get(context))
              : null,
      alignment: alignment,
      child: child,
    );
  }
}

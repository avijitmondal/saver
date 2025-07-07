import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../../utils/theme_helper.dart';

/// A common scaffold to use across all app screens for consistent layout
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool showBackButton;
  final bool showAppBar;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;
  final Widget? drawer;
  final bool useGradientBackground;

  const AppScaffold({
    Key? key,
    required this.body,
    this.title = '',
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.appBar,
    this.showBackButton = true,
    this.showAppBar = true,
    this.padding = UIConstants.paddingPage,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.drawer,
    this.useGradientBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldWidget = Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: showAppBar
          ? appBar ??
              AppBar(
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                centerTitle: true,
                actions: actions,
                automaticallyImplyLeading: showBackButton,
                elevation: UIConstants.elevationSmall,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              )
          : null,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
    );

    if (useGradientBackground) {
      return Container(
        decoration: ThemeHelper.getGradientDecoration(context),
        child: scaffoldWidget,
      );
    }

    return scaffoldWidget;
  }
}

/// A screen layout with a centered content and maximum width
/// Useful for forms and detail screens
class CenteredContentScreen extends StatelessWidget {
  final Widget content;
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final double? maxWidth;
  final Widget? bottomWidget;
  final bool useGradientBackground;

  const CenteredContentScreen({
    Key? key,
    required this.content,
    this.title = '',
    this.actions,
    this.showBackButton = true,
    this.maxWidth,
    this.bottomWidget,
    this.useGradientBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      useGradientBackground: useGradientBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? UIConstants.maxContentWidth,
          ),
          child: Column(
            children: [
              Expanded(child: content),
              if (bottomWidget != null) bottomWidget!,
            ],
          ),
        ),
      ),
    );
  }
}

/// A screen layout with a scrollable content and section headers
/// Useful for profile screens and settings screens
class SectionedScreen extends StatelessWidget {
  final List<Widget> sections;
  final String title;
  final List<Widget>? actions;
  final Widget? bottomWidget;
  final bool showBackButton;
  final bool useGradientBackground;

  const SectionedScreen({
    Key? key,
    required this.sections,
    this.title = '',
    this.actions,
    this.bottomWidget,
    this.showBackButton = true,
    this.useGradientBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      useGradientBackground: useGradientBackground,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: sections.length,
              itemBuilder: (context, index) => sections[index],
            ),
          ),
          if (bottomWidget != null) bottomWidget!,
        ],
      ),
    );
  }
}

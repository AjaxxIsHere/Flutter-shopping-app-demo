import 'package:flutter/material.dart';
import 'package:cart_site/shared_widgets/nav_bar.dart';

// Main layout widget that provides a consistent structure for all screens in the app, including a navigation bar and a body for displaying content
// Widgets: - NavBar: custom widget for the app's navigation bar, displaying the title and providing navigation links to different screens (home, cart, login/register based on authentication state)
class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const MainLayout({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(title: title),
      body: child,
    );
  }
}

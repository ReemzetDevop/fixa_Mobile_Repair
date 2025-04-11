import 'package:flutter/material.dart';

class PageNavigator extends PageRouteBuilder {
  final Widget page;

  PageNavigator({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

void navigateWithFade(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageNavigator(page: page),
  );
}
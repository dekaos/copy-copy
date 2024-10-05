import 'package:flutter/material.dart';
import 'package:copy_copy/views/home/home.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const CopyCopy());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
    ),
  ],
);

class CopyCopy extends StatelessWidget {
  const CopyCopy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}

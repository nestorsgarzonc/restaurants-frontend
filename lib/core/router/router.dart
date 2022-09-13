import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurants/ui/Product/product_detail.dart';
import 'package:restaurants/ui/auth/login_screen.dart';
import 'package:restaurants/ui/error/error_screen.dart';
import 'package:restaurants/ui/menu/index_menu_screen.dart';
import 'package:restaurants/ui/on_boarding/on_boarding.dart';
import 'package:restaurants/ui/table/table_qr_reader_screen.dart';

final routerProvider = Provider<CustomRouter>((ref) {
  return CustomRouter();
});

class CustomRouter {
  CustomRouter();

  static String atributeErrorMessage(String atribute) {
    return 'Es necesario el parametro $atribute';
  }

  final goRouter = GoRouter(
    initialLocation: OnBoarding.route,
    errorBuilder: (context, state) {
      if (state.error == null) {
        return const ErrorScreen();
      }
      return ErrorScreen(error: state.error.toString());
    },
    routes: routes,
  );

  static List<GoRoute> get routes => [
        GoRoute(path: OnBoarding.route, builder: (context, state) => const OnBoarding()),
        GoRoute(
          path: TableQrReaderScreen.route,
          builder: (context, state) => const TableQrReaderScreen(),
        ),
        GoRoute(
          path: IndexMenuScreen.route,
          builder: (context, state) {
            final tableId = state.queryParams['tableId'];
            return tableId == null
                ? ErrorScreen(error: atributeErrorMessage('tableId'))
                : IndexMenuScreen(tableId: tableId);
          },
        ),
        GoRoute(
          path: ErrorScreen.route,
          builder: (context, state) {
            final error = (state.extra as Map<String, dynamic>)['error'];
            if (error == null) {
              return const ErrorScreen();
            }
            return ErrorScreen(error: error);
          },
        ),
        GoRoute(
          path: LoginScreen.route,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: ProductDetail.route,
          builder: (context, state) => const ProductDetail(),
        )
      ];

  BuildContext get context => goRouter.navigator!.context;

  GoRouter get router => goRouter;
}

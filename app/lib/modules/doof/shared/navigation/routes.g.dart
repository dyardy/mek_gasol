// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $signInRoute,
      $signUpRoute,
      $signUpDetailsRoute,
      $userAreaRoute,
    ];

GoRoute get $signInRoute => GoRouteData.$route(
      path: '/sign-in',
      factory: $SignInRouteExtension._fromState,
    );

extension $SignInRouteExtension on SignInRoute {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  String get location => GoRouteData.$location(
        '/sign-in',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

GoRoute get $signUpRoute => GoRouteData.$route(
      path: '/sign-up',
      factory: $SignUpRouteExtension._fromState,
    );

extension $SignUpRouteExtension on SignUpRoute {
  static SignUpRoute _fromState(GoRouterState state) => const SignUpRoute();

  String get location => GoRouteData.$location(
        '/sign-up',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

GoRoute get $signUpDetailsRoute => GoRouteData.$route(
      path: '/sign-details',
      factory: $SignUpDetailsRouteExtension._fromState,
    );

extension $SignUpDetailsRouteExtension on SignUpDetailsRoute {
  static SignUpDetailsRoute _fromState(GoRouterState state) =>
      const SignUpDetailsRoute();

  String get location => GoRouteData.$location(
        '/sign-details',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

GoRoute get $userAreaRoute => GoRouteData.$route(
      path: '/',
      factory: $UserAreaRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'products/:productId',
          factory: $ProductRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'orders/:orderId',
          factory: $OrderRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'products/:productId',
              factory: $OrderProductRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $UserAreaRouteExtension on UserAreaRoute {
  static UserAreaRoute _fromState(GoRouterState state) => const UserAreaRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $ProductRouteExtension on ProductRoute {
  static ProductRoute _fromState(GoRouterState state) => ProductRoute(
        state.params['productId']!,
      );

  String get location => GoRouteData.$location(
        '/products/${Uri.encodeComponent(productId)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $OrderRouteExtension on OrderRoute {
  static OrderRoute _fromState(GoRouterState state) => OrderRoute(
        state.params['orderId']!,
      );

  String get location => GoRouteData.$location(
        '/orders/${Uri.encodeComponent(orderId)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $OrderProductRouteExtension on OrderProductRoute {
  static OrderProductRoute _fromState(GoRouterState state) => OrderProductRoute(
        state.params['orderId']!,
        state.params['productId']!,
      );

  String get location => GoRouteData.$location(
        '/orders/${Uri.encodeComponent(orderId)}/products/${Uri.encodeComponent(productId)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

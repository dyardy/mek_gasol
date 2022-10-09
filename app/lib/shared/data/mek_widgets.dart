import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget _buildWithScaffold(BuildContext context, Widget child) {
  if (Material.of(context) == null) {
    return Material(
      child: InkWell(
        onTap: () => context.pop(),
        child: child,
      ),
    );
  }
  return child;
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    const child = Center(
      child: CircularProgressIndicator(),
    );
    return _buildWithScaffold(context, child);
  }
}

class ErrorView extends StatelessWidget {
  final Object error;

  const ErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    const child = InfoView(
      icon: Icon(Icons.error_outline),
      title: Text('🤖 My n_m_ _s r_b_t! 🤖'),
    );
    return _buildWithScaffold(context, child);
  }
}

class InfoView extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? icon;
  final Widget title;

  const InfoView({
    super.key,
    this.onTap,
    this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme.merge(
              data: const IconThemeData(size: 48.0),
              child: icon ?? const Icon(Icons.info_outline, size: 48.0),
            ),
            const SizedBox(height: 16.0),
            DefaultTextStyle.merge(
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
              child: title,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorView extends StatelessWidget {
  final Object error;

  const ErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline),
          Text('🤖 My n_m_ _s r_b_t! 🤖'),
        ],
      ),
    );
  }
}

class InfoView extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget title;

  const InfoView({
    super.key,
    this.onTap,
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
            const Icon(Icons.info_outline, size: 48.0),
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

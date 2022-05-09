import 'package:flutter/widgets.dart';

class AppListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget title;
  final Widget? trailing;

  const AppListTile({
    Key? key,
    this.onTap,
    required this.title,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              title,
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}

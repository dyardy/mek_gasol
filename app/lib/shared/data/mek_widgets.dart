import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MekProgressIndicator extends StatelessWidget {
  const MekProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mek = MekProvider.of(context);
    return mek.progressIndicatorBuilder(context, const MekProgressIndicatorData());
  }
}

class MekProgressIndicatorData {
  const MekProgressIndicatorData();
}

class MekCrashIndicator extends StatelessWidget {
  const MekCrashIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mek = MekProvider.of(context);
    return mek.crashIndicatorBuilder(context, const MekCrashIndicatorData());
  }
}

class MekCrashIndicatorData {
  const MekCrashIndicatorData();
}

enum MekStyle { material, cupertino }

class MekProvider extends InheritedWidget {
  final MekStyle style;
  final Widget Function(BuildContext context, MekProgressIndicatorData data)
      progressIndicatorBuilder;
  final Widget Function(BuildContext context, MekCrashIndicatorData data) crashIndicatorBuilder;

  const MekProvider({
    Key? key,
    required Widget child,
    required this.style,
    required this.progressIndicatorBuilder,
    required this.crashIndicatorBuilder,
  }) : super(key: key, child: child);

  static MekProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MekProvider>()!;
  }

  @override
  bool updateShouldNotify(MekProvider oldWidget) {
    return style != oldWidget.style;
  }
}

class CupertinoMekProvider extends StatelessWidget {
  final Widget child;

  const CupertinoMekProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MekProvider(
      style: MekStyle.cupertino,
      progressIndicatorBuilder: (context, data) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
      crashIndicatorBuilder: (context, data) {
        return const Center(
          child: Icon(CupertinoIcons.ant),
        );
      },
      child: child,
    );
  }
}

class MaterialMekProvider extends StatelessWidget {
  final Widget child;

  const MaterialMekProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MekProvider(
      style: MekStyle.material,
      progressIndicatorBuilder: (context, data) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      crashIndicatorBuilder: (context, data) {
        return const Center(
          child: Icon(Icons.bug_report_outlined),
        );
      },
      child: child,
    );
  }
}

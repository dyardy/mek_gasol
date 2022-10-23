import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:mek/src/consumer/_source_consumer.dart' as sr;

/// An object that allows widgets to interact with sources.
///
/// Combined component between flutter_source and riverpod packages.
/// See [rv.WidgetRef] and [sr.WidgetRef]
abstract class WidgetRef implements rv.WidgetRef, sr.WidgetRef {}

/// Combined component between flutter_source and riverpod packages.
/// See [rv.ConsumerWidget] and [sr.ConsumerWidget]
class Consumer extends ConsumerWidget {
  /// A function that can also listen to providers
  ///
  /// See also [Consumer]
  final Widget Function(BuildContext context, WidgetRef ref, Widget? child) builder;

  /// See [Consumer]
  final Widget? child;

  const Consumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => builder(context, ref, child);

  @override
  ConsumerState createState() => _ConsumerState();
}

/// Combined component between flutter_source and riverpod packages.
/// See [rv.ConsumerWidget] and [sr.ConsumerWidget]
abstract class ConsumerWidget extends ConsumerStatefulWidget {
  const ConsumerWidget({super.key});

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree
  /// in a given [BuildContext] and when the dependencies of this widget change
  /// (e.g., an [InheritedWidget] referenced by this widget changes). This
  /// method can potentially be called in every frame and should not have any side
  /// effects beyond building a widget.
  ///
  /// The framework replaces the subtree below this widget with the widget
  /// returned by this method, either by updating the existing subtree or by
  /// removing the subtree and inflating a new subtree, depending on whether the
  /// widget returned by this method can update the root of the existing
  /// subtree, as determined by calling [Widget.canUpdate].
  ///
  /// Typically implementations return a newly created constellation of widgets
  /// that are configured with information from this widget's constructor and
  /// from the given [BuildContext].
  ///
  /// The given [BuildContext] contains information about the location in the
  /// tree at which this widget is being built. For example, the context
  /// provides the set of inherited widgets for this location in the tree. A
  /// given widget might be built with multiple different [BuildContext]
  /// arguments over time if the widget is moved around the tree or if the
  /// widget is inserted into the tree in multiple places at once.
  ///
  /// The implementation of this method must only depend on:
  ///
  /// * the fields of the widget, which themselves must not change over time,
  ///   and
  /// * any ambient state obtained from the `context` using
  ///   [BuildContext.dependOnInheritedWidgetOfExactType].
  ///
  /// If a widget's [build] method is to depend on anything else, use a
  /// [StatefulWidget] instead.
  ///
  /// See also:
  ///
  ///  * [StatelessWidget], which contains the discussion on performance considerations.
  Widget build(BuildContext context, WidgetRef ref);

  @override
  ConsumerState createState() => _ConsumerState();
}

class _ConsumerState extends ConsumerState<ConsumerWidget> {
  @override
  Widget build(BuildContext context) => widget.build(context, ref);
}

/// Combined component between flutter_source and riverpod packages.
/// See [rv.ConsumerStatefulWidget] and [sr.ConsumerStatefulWidget]
abstract class ConsumerStatefulWidget extends rv.ConsumerStatefulWidget {
  const ConsumerStatefulWidget({super.key});

  @override
  ConsumerState createState();

  @override
  ConsumerStatefulElement createElement() => ConsumerStatefulElement(this);
}

/// Combined component between flutter_source and riverpod packages.
/// See [rv.ConsumerState] and [sr.ConsumerState]
abstract class ConsumerState<T extends rv.ConsumerStatefulWidget> extends rv.ConsumerState<T> {
  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  Widget build(BuildContext context);
}

/// Combined component between flutter_source and riverpod packages.
/// See [rv.ConsumerStatefulElement] and [sr.ConsumerStatefulElement]
class ConsumerStatefulElement extends rv.ConsumerStatefulElement
    with sr.ConsumerStatefulElement
    implements WidgetRef {
  ConsumerStatefulElement(super.widget);
}

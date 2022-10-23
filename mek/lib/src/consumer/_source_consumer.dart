import 'package:flutter/widgets.dart';
import 'package:mek/src/consumer/source.dart';

/// An object that allows widgets to interact with sources.
abstract class WidgetRef {
  /// The [BuildContext] of the widget associated to this [WidgetRef].
  ///
  /// This is strictly identical to the [BuildContext] passed to [ConsumerWidget.build].
  BuildContext get context;

  /// Returns the value exposed by a source and rebuild the widget when that
  /// value changes.
  ///
  /// See also:
  ///
  /// - [Source.select], which allows a widget to filter rebuilds by
  ///   observing only the selected properties.
  /// - [observe], to react to changes on a source, such as for showing modals.
  T react<T>(Source<T> source, {SourceCondition<T>? when});

  /// Listen to a source and call [listener] whenever its value changes,
  /// without having to take care of removing the listener.
  ///
  /// The [listen] method should exclusively be used within the `build` method
  /// of a widget:
  ///
  /// ```dart
  /// Consumer(
  ///   builder: (context, ref, child) {
  ///     ref.listen<int>(counterSource, (prev, next) {
  ///       print('counter changed $next');
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// When used inside `build`, listeners will automatically be removed
  /// if a widget rebuilds and stops listening to a source.
  ///
  /// For listening to a source from outside `build`, consider using [observeManual] instead.
  ///
  /// This is useful for showing modals or other imperative logic.
  void observe<T>(Source<T> source, SourceListener<T> listener, {SourceCondition<T>? when});

  /// Listen to a source and call [listener] whenever its value changes.
  ///
  /// As opposed to [observe], [observeManual] is not safe to use within the `build`
  /// method of a widget.
  /// Instead, [observeManual] is designed to be used inside [State.initState] or
  /// other [State] lifecycles.
  ///
  /// [observeManual] returns a [SourceSubscription] which can be used to stop
  /// listening to the source, or to read the current value exposed by
  /// the source.
  ///
  /// It is not necessary to call [SourceSubscription.cancel] inside [State.dispose].
  /// When the widget that calls [observeManual] is disposed, the subscription
  /// will be disposed automatically.
  SourceSubscription<T> observeManual<T>(
    Source<T> source,
    SourceListener<T> listener, {
    bool fireImmediately = false,
    SourceCondition<T>? when,
  });
}

/// {@template flutter_source.consumer}
/// Build a widget tree while listening to sources.
///
/// [Consumer] can be used to listen to sources inside a [StatefulWidget]
/// or to rebuild as few widgets as possible when a source updates.
///
/// As an example, consider:
///
/// ```dart
/// final helloWorldListenable = ValueListenable('Hello world');
/// ```
///
/// We can then use [Consumer] to listen to `helloWorldListenable` inside a
/// [StatefulWidget] like so:
///
/// ```dart
/// class Example extends StatefulWidget {
///   @override
///   _ExampleState createState() => _ExampleState();
/// }
///
/// class _ExampleState extends State<Example> {
///   @override
///   Widget build(BuildContext context) {
///     return Consumer(
///       builder: (context, ref, child) {
///         final value = ref.react(helloWorldListenable.toSource());
///         return Text(value); // Hello world
///       },
///     );
///   }
/// }
/// ```
///
/// **Note**
/// You can watch as many sources inside [Consumer] as you want to:
///
/// ```dart
/// Consumer(
///   builder: (context, ref, child) {
///     final value = ref.react(someListenable.toSource());
///     final another = ref.react(anotherListenable.toSource());
///     ...
///   },
/// );
/// ```
///
/// ## Performance optimizations
///
/// If your `builder` function contains a subtree that does not depend on the
/// animation, it is more efficient to build that subtree once instead of
/// rebuilding it on every source update.
///
/// If you pass the pre-built subtree as the `child` parameter, the
/// Consumer will pass it back to your builder function so that you
/// can incorporate it into your build.
///
/// Using this pre-built child is entirely optional, but can improve
/// performance significantly in some cases and is therefore a good practice.
///
/// This sample shows how you could use a [Consumer]
///
/// ```dart
/// final counterListenable = ValueListenable(0);
///
/// class MyHomePage extends StatelessWidget {
///   MyHomePage({Key? key, required this.title}) : super(key: key);
///   final String title;
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(title)
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: <Widget>[
///             Text('You have pushed the button this many times:'),
///             Consumer(
///               builder: (BuildContext context, WidgetRef ref, Widget? child) {
///                 // This builder will only get called when the counterListenable
///                 // is updated.
///                 final count = ref.react(counterListenable.toSource());
///
///                 return Row(
///                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///                   children: <Widget>[
///                     Text('$count'),
///                     child!,
///                   ],
///                 );
///               },
///               // The child parameter is most helpful if the child is
///               // expensive to build and does not depend on the value from
///               // the notifier.
///               child: Text('Good job!'),
///             )
///           ],
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         child: Icon(Icons.plus_one),
///         onPressed: () => counterListenable.value++,
///       ),
///     );
///   }
/// }
/// ```
///
/// See also:
///
///  * [ConsumerWidget], a base-class for widgets that wants to listen to sources.
/// {@endtemplate}
class Consumer extends ConsumerWidget {
  /// A function that can also listen to providers
  ///
  /// See also [Consumer]
  final Widget Function(BuildContext context, WidgetRef ref, Widget? child) builder;

  /// See [Consumer]
  final Widget? child;

  /// {@template flutter_source.consumer}
  const Consumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => builder(context, ref, child);

  @override
  State<ConsumerStatefulWidget> createState() => _ConsumerState();
}

/// {@template flutter_source.consumerwidget}
/// A [StatelessWidget] that can listen to sources.
///
/// Using [ConsumerWidget], this allows the widget tree to listen to changes on
/// source, so that the UI automatically updates when needed.
///
/// Do not modify any state or start any http request inside [build].
///
/// As a usage example, consider:
///
/// ```dart
/// final helloWorldListenable = ValueListenable('Hello world');
/// ```
///
/// We can then subclass [ConsumerWidget] to listen to `helloWorldListenable` like so:
///
/// ```dart
/// class Example extends ConsumerWidget {
///   const Example({Key? key}): super(key: key);
///
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final value = ref.react(helloWorldListenable.toSource());
///     return Text(value); // Hello world
///   }
/// }
/// ```
///
/// **Note**
/// You can watch as many sources inside [build] as you want to:
///
/// ```dart
/// @override
/// Widget build(BuildContext context, WidgetRef ref) {
///   final value = ref.react(someListenable.toSource());
///   final another = ref.react(anotherListenable.toSource());
///   return Text(value); // Hello world
/// }
/// ```
///
/// For reading sources inside a [StatefulWidget] or for performance
/// optimizations, see [Consumer].
/// {@endtemplate}
abstract class ConsumerWidget extends ConsumerStatefulWidget {
  /// {@macro flutter_source.consumerwidget}
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
  State<ConsumerStatefulWidget> createState() => _ConsumerState();
}

class _ConsumerState extends ConsumerState<ConsumerWidget> {
  @override
  Widget build(BuildContext context) => widget.build(context, ref);
}

/// A [StatefulWidget] that can read sources.
abstract class ConsumerStatefulWidget extends StatefulWidget {
  /// A [StatefulWidget] that can read sources.
  const ConsumerStatefulWidget({super.key});

  @override
  State<ConsumerStatefulWidget> createState();

  @override
  StatefulElement createElement() => _ConsumerStatefulElement(this);
}

/// A [State] that has access to a [WidgetRef] through [ref], allowing
/// it to read sources.
abstract class ConsumerState<T extends ConsumerStatefulWidget> extends State<T> {
  /// An object that allows widgets to interact with sources.
  late final WidgetRef ref = context as WidgetRef;

  @override
  Widget build(BuildContext context);
}

class _ConsumerStatefulElement extends StatefulElement with ConsumerStatefulElement {
  _ConsumerStatefulElement(super.widget);
}

/// The [Element] for a [ConsumerStatefulWidget]
mixin ConsumerStatefulElement on StatefulElement implements WidgetRef {
  var _dependencies = <Source<Object?>, SourceSubscription<Object?>>{};
  var _oldDependencies = <Source<Object?>, SourceSubscription<Object?>>{};

  final _listeners = <SourceSubscription<Object?>>[];

  final _manualListeners = <SourceSubscription<Object?>>[];

  @override
  BuildContext get context => this;

  @override
  void observe<T>(Source<T> source, SourceListener<T> listener, {SourceCondition<T>? when}) {
    _listeners.add(source.listen()
      ..listenWhen = when
      ..listener = listener);
  }

  @override
  SourceSubscription<T> observeManual<T>(
    Source<T> source,
    SourceListener<T> listener, {
    bool fireImmediately = false,
    SourceCondition<T>? when,
  }) {
    final subscription = _ListenManual(source.listen(), this)
      ..listenWhen = when
      ..listener = listener;
    _manualListeners.add(subscription);
    if (fireImmediately) listener(subscription.read());
    return subscription;
  }

  @override
  T react<T>(Source<T> source, {SourceCondition<T>? when}) {
    final subscription = _dependencies.putIfAbsent(source, () {
      final oldDependency = _oldDependencies.remove(source);

      if (oldDependency != null) return oldDependency;

      return source.listen()..listener = _markNeedsBuild;
    }) as SourceSubscription<T>;
    return (subscription..listenWhen = when).read();
  }

  @override
  void unmount() {
    for (final subscription in _dependencies.values) {
      subscription.cancel();
    }
    for (final subscription in _listeners) {
      subscription.cancel();
    }
    super.unmount();
  }

  void _markNeedsBuild(dynamic _) => markNeedsBuild();

  @override
  Widget build() {
    _oldDependencies = _dependencies;
    _dependencies = {};

    for (final subscription in _listeners) {
      subscription.cancel();
    }
    _listeners.clear();

    try {
      return super.build();
    } finally {
      for (final subscription in _oldDependencies.values) {
        subscription.cancel();
      }
      _oldDependencies = {};
    }
  }
}

class _ListenManual<T> implements SourceSubscription<T> {
  final SourceSubscription<T> _subscription;
  final ConsumerStatefulElement _element;

  _ListenManual(this._subscription, this._element);

  @override
  set listener(SourceListener<T> listener) {
    _subscription.listener = listener;
  }

  @override
  set listenWhen(SourceCondition<T>? condition) {
    _subscription.listenWhen = condition;
  }

  @override
  T read() => _subscription.read();

  @override
  void cancel() {
    _subscription.cancel();
    _element._manualListeners.remove(this);
  }
}

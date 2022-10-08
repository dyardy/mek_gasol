import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';

class AsyncViewBuilder<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<T>> provider;
  final Widget Function(BuildContext context, WidgetRef ref, T data) builder;

  const AsyncViewBuilder({
    super.key,
    required this.provider,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    if (state.hasValue) {
      return builder(context, ref, state.requiredValue);
    }
    if (state.hasError) {
      return ErrorView(error: state.error!);
    }
    return const LoadingView();
  }
}

// class BuildRef implements BuildContext, WidgetRef {
//   final BuildContext context;
//   final WidgetRef ref;
//
//
//   BuildRef(this.context, this.ref);
//
//   @override
//   bool get debugDoingBuild => context.debugDoingBuild;
//
//   @override
//   InheritedWidget dependOnInheritedElement(InheritedElement ancestor, {Object? aspect}) {
//     return context.dependOnInheritedElement(ancestor, aspect: aspect);
//   }
//
//   @override
//   T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({Object? aspect}) {
//     return context.dependOnInheritedWidgetOfExactType(aspect: aspect);
//   }
//
//   @override
//   DiagnosticsNode describeElement(String name, {DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty}) {
//     return context.describeElement(name, style: style);
//   }
//
//   @override
//   List<DiagnosticsNode> describeMissingAncestor({required Type expectedAncestorType}) {
//     return context.describeMissingAncestor(expectedAncestorType: expectedAncestorType);
//   }
//
//   @override
//   DiagnosticsNode describeOwnershipChain(String name) {
//     return context.describeOwnershipChain(name);
//   }
//
//   @override
//   DiagnosticsNode describeWidget(String name, {DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty}) {
//     return context.describeWidget(name);
//   }
//
//   @override
//   void dispatchNotification(Notification notification) {
//     context.dispatchNotification(notification);
//   }
//
//   @override
//   T? findAncestorRenderObjectOfType<T extends RenderObject>() {
//     return context.findAncestorRenderObjectOfType<T>();
//   }
//
//   @override
//   T? findAncestorStateOfType<T extends State<StatefulWidget>>() {
//     return context.findAncestorStateOfType();
//   }
//
//   @override
//   T? findAncestorWidgetOfExactType<T extends Widget>() {
//     return context.findAncestorWidgetOfExactType();
//   }
//
//   @override
//   RenderObject? findRenderObject() {
//     return context.findRenderObject();
//   }
//
//   @override
//   T? findRootAncestorStateOfType<T extends State<StatefulWidget>>() {
//     return context.findRootAncestorStateOfType();
//   }
//
//   @override
//   InheritedElement? getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
//     return context.getElementForInheritedWidgetOfExactType();
//   }
//
//   @override
//   BuildOwner? get owner => context.owner;
//
//   @override
//   Size? get size => context.size;
//
//   @override
//   void visitAncestorElements(bool Function(Element element) visitor) {
//     context.visitAncestorElements(visitor);
//   }
//
//   @override
//   void visitChildElements(ElementVisitor visitor) {
//     context.visitChildElements(visitor);
//   }
//
//   @override
//   Widget get widget => context.widget;
//
//   @override
//   void invalidate(ProviderOrFamily provider) {
//     ref.invalidate(provider);
//   }
//
//   @override
//   void listen<T>(ProviderListenable<T> provider, void Function(T? previous, T next) listener, {void Function(Object error, StackTrace stackTrace)? onError}) {
//     ref.listen(provider, listener, onError: onError);
//   }
//
//   @override
//   ProviderSubscription<T> listenManual<T>(ProviderListenable<T> provider, void Function(T? previous, T next) listener, {void Function(Object error, StackTrace stackTrace)? onError, bool fireImmediately}) {
//     return ref.lis
//   }
//
//   @override
//   T read<T>(ProviderListenable<T> provider) {
//     // TODO: implement read
//     throw UnimplementedError();
//   }
//
//   @override
//   State refresh<State>(Refreshable<State> provider) {
//     // TODO: implement refresh
//     throw UnimplementedError();
//   }
//
//   @override
//   T watch<T>(ProviderListenable<T> provider) {
//     // TODO: implement watch
//     throw UnimplementedError();
//   }
// }

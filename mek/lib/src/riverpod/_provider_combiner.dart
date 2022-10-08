// ignore_for_file: invalid_use_of_internal_member, implementation_imports

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/src/internals.dart';
import 'package:riverpod/src/stack_trace.dart';

// ignore: unused_element
var _debugIsRunningCombiner = false;

/// An internal class for `ProviderBase.combine`.
@sealed
class ProviderCombiner<Input, Output> with ProviderListenable<Output> {
  /// An internal class for `ProviderBase.combine`.
  ProviderCombiner({
    required this.providers,
    required this.combiner,
  });

  /// The provider that was selected
  final Iterable<ProviderListenable<Input>> providers;

  /// The selector applied
  final Output Function(List<Input> input) combiner;

  Result<Output> _combine(List<Result<Input>> values) {
    assert(
      () {
        _debugIsRunningCombiner = true;
        return true;
      }(),
      '',
    );

    try {
      final errors = values.whereType<ResultError<Input>>();
      if (errors.isNotEmpty) {
        return Result.error(errors.first.error, errors.first.stackTrace);
      }

      final inputs = values.map((result) => (result as ResultData<Input>).state).toList();
      return Result.data(combiner(inputs));
    } catch (err, stack) {
      // TODO test
      return Result.error(err, stack);
    } finally {
      assert(
        () {
          _debugIsRunningCombiner = false;
          return true;
        }(),
        '',
      );
    }
  }

  void _selectOnChange({
    required List<Result<Input>> newState,
    required Result<Output> lastCombinedValue,
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function(Output? prev, Output next) listener,
    required void Function(Result<Output> newState) onChange,
  }) {
    final newSelectedValue = _combine(newState);
    if (!lastCombinedValue.hasState ||
        !newSelectedValue.hasState ||
        lastCombinedValue.requireState != newSelectedValue.requireState) {
      // TODO test events after selector exception correctly send `previous`s

      onChange(newSelectedValue);
      // TODO test handle exception in listener
      newSelectedValue.map(
        data: (data) {
          listener(
            // TODO test from error
            lastCombinedValue.stateOrNull,
            data.state,
          );
        },
        error: (error) => onError(error.error, error.stackTrace),
      );
    }
  }

  @override
  ProviderSubscription<Output> addListener(
    Node node,
    void Function(Output? previous, Output next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    onError ??= Zone.current.handleUncaughtError;

    late List<Result<Input>> lastValues;
    late Result<Output> lastCombinedValue;

    final subs = providers.mapIndexed((index, provider) {
      return node.listen<Input>(
        provider,
        (prev, input) {
          _selectOnChange(
            newState: (lastValues..[index] = Result.data(input)),
            lastCombinedValue: lastCombinedValue,
            listener: listener,
            onError: onError!,
            onChange: (newState) => lastCombinedValue = newState,
          );
        },
        onError: onError,
      );
    }).toList();

    lastValues = subs.map((sub) => Result.guard(sub.read)).toList();
    lastCombinedValue = _combine(lastValues);

    if (fireImmediately) {
      handleFireImmediately(
        lastCombinedValue,
        listener: listener,
        onError: onError,
      );
    }

    return _CombinerSubscription(
      subs,
      () {
        return lastCombinedValue.map(
          data: (data) => data.state,
          error: (error) => throwErrorWithCombinedStackTrace(
            error.error,
            error.stackTrace,
          ),
        );
      },
    );
  }

  @override
  Output read(Node node) {
    final input = providers.map((provider) => provider.read(node)).toList();
    return combiner(input);
  }
}

class _CombinerSubscription<Input, Output> implements ProviderSubscription<Output> {
  _CombinerSubscription(this._subs, this._read);

  final Iterable<ProviderSubscription<Input>> _subs;
  final Output Function() _read;
  var _closed = false;

  @override
  void close() {
    _closed = true;
    for (final sub in _subs) {
      sub.close();
    }
  }

  @override
  Output read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    // flushes the provider
    for (final sub in _subs) {
      sub.read();
    }

    return _read();
  }
}

// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mek/src/consumer/_source_consumer.dart';
import 'package:mek/src/consumer/source_extensions.dart';

class ValueCubit<T> extends Cubit<T> {
  ValueCubit(super.initialState);
}

void main() {
  testWidgets('ValueListenable', (tester) async {
    final listenable = ValueNotifier(0);

    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer(
        builder: (context, ref, _) {
          final value = ref.react(listenable.toSource(), when: (prev, next) {
            print('$prev $next');
            return true;
          });
          print('Build: $value');
          return Text('$value');
        },
      ),
    ));

    listenable.value += 1;
    listenable.value += 1;
    listenable.value += 1;

    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('Bloc', (tester) async {
    final bloc = ValueCubit(0);

    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer(
        builder: (context, ref, _) {
          final value = ref.react(bloc.toSource(), when: (prev, next) {
            return true;
          });
          return Text('$value');
        },
      ),
    ));

    bloc.emit(bloc.state + 1);
    bloc.emit(bloc.state + 1);
    bloc.emit(bloc.state + 1);

    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('Bloc Listening', (tester) async {
    final bloc = ValueNotifier(0);
    var c = 1;

    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer(
        builder: (context, ref, _) {
          var a = c;
          ref.observe(bloc.toSource(), (state) {
            print(a);
          });
          return const SizedBox.shrink();
        },
      ),
    ));

    bloc.value += 1;
    c += 1;
    bloc.value += 1;

    await tester.pumpAndSettle();
  });
}

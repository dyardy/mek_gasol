import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart' hide MutationBloc, MutationState;
import 'package:mek_gasol/modules/gasol/features/matches/dvo/match_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/matches/triggers/matches_trigger.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/players/widgets/players.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/rivertion.dart';

class MatchFormBloc extends ListFieldBloc<dynamic> {
  final MatchDvo? match;

  final teamsFB = FieldBloc<Map<Team, List<PlayerDvo>>>(
    initialValue: {},
    validator: _validateTeam,
  );

  final leftPointsFB = FieldBloc(
    initialValue: 0,
    validator: const NumberValidation(greaterThan: 0),
  );
  final rightPointsFB = FieldBloc(
    initialValue: 0,
    validator: const NumberValidation(greaterThan: 0),
  );

  MatchFormBloc({required this.match}) {
    teamsFB.updateValue({
      Team.left: match?.leftPlayers ?? const [],
      Team.right: match?.rightPlayers ?? const [],
    });
    leftPointsFB.updateValue(match?.leftPoints ?? 0);
    rightPointsFB.updateValue(match?.rightPoints ?? 0);

    addFieldBlocs([teamsFB, leftPointsFB, rightPointsFB]);
  }

  static Object? _validateTeam(Map<Team, List<PlayerDvo>> values) {
    final leftCount = values[Team.left]?.length ?? 0;
    final rightCount = values[Team.right]?.length ?? 0;

    if (leftCount < 1 && rightCount < 1) return 'Missing Red and Blue';
    if (leftCount < 1) return 'Missing Red';
    if (rightCount < 1) return 'Missing Blue';

    return null;
  }
}

class MatchBloc {
  static final form = BlocProvider.family
      .autoDispose<MatchFormBloc, ListFieldBlocState<dynamic>, MatchDvo?>((ref, match) {
    return MatchFormBloc(match: match);
  });

  static final save = MutationProvider.autoDispose<MatchDvo?, void>((ref) {
    return MutationBloc((match) {
      final formBloc = ref.read(form(match).bloc);
      final teams = formBloc.teamsFB.state.value;

      ref.read(MatchesTrigger.instance).save(
            matchId: formBloc.match?.id,
            leftPlayers: teams[Team.left]!.toList(),
            rightPlayers: teams[Team.right]!.toList(),
            leftPoints: formBloc.leftPointsFB.state.value,
            rightPoint: formBloc.rightPointsFB.state.value,
          );
    });
  });
}

class MatchScreen extends ConsumerWidget {
  final MatchDvo? match;

  const MatchScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  void save(WidgetRef ref) {
    ref.read(MatchBloc.save.bloc).maybeMutate(match);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formBloc = ref.watch(MatchBloc.form(match).bloc);

    ref.listen<MutationState<void>>(MatchBloc.save, (previous, next) {
      next.maybeMap(success: (_) {
        context.hub.pop();
      }, orElse: (_) {
        //
      });
    });

    final form = Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                'RED TEAM',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
            Expanded(
              child: Text(
                'BLUE TEAM',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FieldText(
                fieldBloc: formBloc.leftPointsFB,
                converter: FieldConvert.integer,
                type: const TextFieldType.numeric(),
              ),
            ),
            Expanded(
              child: FieldText(
                fieldBloc: formBloc.rightPointsFB,
                converter: FieldConvert.integer,
                type: const TextFieldType.numeric(),
              ),
            ),
          ],
        ),
        BlocBuilder<FieldBlocState<Map<Team, List<PlayerDvo>>>>(
          bloc: formBloc.teamsFB,
          builder: (context, state) {
            final leftTeam = state.value[Team.left] ?? [];
            final rightTeam = state.value[Team.right] ?? [];

            final teams = Row(
              children: [
                Expanded(
                  child: Column(
                    children: leftTeam.map((e) {
                      return Text(e.username);
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: rightTeam.map((e) {
                      return Text(e.username);
                    }).toList(),
                  ),
                )
              ],
            );

            final teamsWithError = InputDecorator(
              decoration: InputDecoration(
                errorText: state.isInvalid ? '${state.errors.first}' : null,
              ),
              child: Column(
                children: [
                  teams,
                  if (leftTeam.isEmpty && rightTeam.isEmpty) const Text('Tap to choose Players'),
                ],
              ),
            );

            return GestureDetector(
              onTap: () async {
                final teams =
                    await context.hub.push<Map<Team, List<PlayerDvo>>>(const _TeamsScreen());
                if (teams == null) return;
                formBloc.teamsFB.updateValue(teams);
              },
              child: teamsWithError,
            );
          },
        ),
      ],
    );

    final buttonBar = Consumer(
      builder: (context, ref, _) {
        final canSave = ref.watch(MatchBloc.save.select((state) => !state.isMutating));

        final saveButton = BlocBuilder<ListFieldBlocState<dynamic>>(
          bloc: formBloc,
          builder: (context, state) {
            return ElevatedButton(
              onPressed: canSave && state.isValid ? () => save(ref) : null,
              child: const Text('Save'),
            );
          },
        );

        return SizedBox(
          width: double.infinity,
          child: saveButton,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: form,
            ),
            buttonBar,
          ],
        ),
      ),
    );
  }
}

enum Team { left, none, right }

class _TeamsScreen extends ConsumerStatefulWidget {
  const _TeamsScreen({Key? key}) : super(key: key);

  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<_TeamsScreen> {
  final _players = FieldBloc<Map<PlayerDvo, Team>>(
    initialValue: {},
    validator: _validate,
  );

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // TODO: Improve it with update by id
    final players = await ref.watch(PlayersBloc.all.future);
    _players.updateValue({
      for (final player in players) player: Team.none,
    });
  }

  @override
  void dispose() {
    _players.close();
    super.dispose();
  }

  static Object? _validate(Map<PlayerDvo, Team> values) {
    final leftCount = values.values.fold<int>(0, (count, e) => e == Team.left ? count + 1 : count);
    final rightCount =
        values.values.fold<int>(0, (count, e) => e == Team.right ? count + 1 : count);

    if (leftCount < 1) return 'Missing Red';
    if (rightCount < 1) return 'Missing Blue';

    return null;
  }

  void save() {
    final values = _players.state.value;
    final result = values.entries
        .groupListsBy((element) => element.value)
        .map((key, value) => MapEntry(key, value.map((e) => e.key).toList()));
    context.hub.pop(result);
  }

  // children: values.entries.map((e) {
  //   return CupertinoFormRow(
  //     prefix: Text(e.key.username),
  //     child: CupertinoSlidingSegmentedControl<Team>(
  //       groupValue: e.value,
  //       onValueChanged: (team) =>
  //           _players.updateValue({...values, e.key: team ?? Team.none}),
  //       children: const {
  //         Team.left: Text(
  //           'RED',
  //           style: TextStyle(color: CupertinoColors.systemRed),
  //         ),
  //         Team.none: Text('None'),
  //         Team.right: Text(
  //           'BLUE',
  //           style: TextStyle(color: CupertinoColors.systemBlue),
  //         ),
  //       },
  //     ),
  //   );
  // }).toList(),

  @override
  Widget build(BuildContext context) {
    final players = BlocBuilder<FieldBlocState<Map<PlayerDvo, Team>>>(
      bloc: _players,
      builder: (context, state) {
        final values = state.value;
        return FieldGroupBuilder(
          fieldBloc: _players,
          valuesCount: values.length,
          valueBuilder: (state, index) {
            return Chip(label: Text('$index'));
          },
        );
      },
    );

    final error = BlocBuilder<FieldBlocState<Map<PlayerDvo, Team>>>(
      bloc: _players,
      builder: (context, state) {
        if (state.isValid) return const SizedBox.shrink();

        return Align(
          alignment: AlignmentDirectional.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 24.0),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
              child: Text('${state.errors.first}'),
            ),
          ),
        );
      },
    );

    final checkButton = BlocBuilder<FieldBlocState<Map<PlayerDvo, Team>>>(
      bloc: _players,
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: state.isValid ? save : null,
          child: const Icon(Icons.check),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: checkButton,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: players,
            ),
            error,
          ],
        ),
      ),
    );
  }
}

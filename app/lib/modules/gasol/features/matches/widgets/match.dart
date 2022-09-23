import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/gasol/features/matches/dvo/match_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/matches/triggers/matches_trigger.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/shared/hub.dart';

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

class MatchScreen extends StatefulWidget {
  final MatchDvo? match;

  const MatchScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final _saveMb = MutationBloc();

  late final _form = MatchFormBloc(match: widget.match);

  void save() {
    _saveMb.handle(() async {
      final teams = _form.teamsFB.state.value;

      await get<MatchesTrigger>().save(
        matchId: _form.match?.id,
        leftPlayers: teams[Team.left]!.toList(),
        rightPlayers: teams[Team.right]!.toList(),
        leftPoints: _form.leftPointsFB.state.value,
        rightPoint: _form.rightPointsFB.state.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _saveMb,
      listener: (context, state) => state.whenOrNull(success: (_) {
        context.hub.pop();
      }),
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
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
                fieldBloc: _form.leftPointsFB,
                converter: FieldConvert.integer,
                type: const TextFieldType.numeric(),
              ),
            ),
            Expanded(
              child: FieldText(
                fieldBloc: _form.rightPointsFB,
                converter: FieldConvert.integer,
                type: const TextFieldType.numeric(),
              ),
            ),
          ],
        ),
        BlocBuilder<FieldBlocState<Map<Team, List<PlayerDvo>>>>(
          bloc: _form.teamsFB,
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
                _form.teamsFB.updateValue(teams);
              },
              child: teamsWithError,
            );
          },
        ),
      ],
    );

    final buttonBar = SizedBox(
      width: double.infinity,
      child: ButtonBuilder(
        onPressed: save,
        formBloc: _form,
        mutationBlocs: [_saveMb],
        builder: (context, onPressed) {
          return ElevatedButton(
            onPressed: onPressed,
            child: const Text('Save'),
          );
        },
      ),
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

class _TeamsScreen extends StatefulWidget {
  const _TeamsScreen({Key? key}) : super(key: key);

  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<_TeamsScreen> {
  final _players = FieldBloc<Map<PlayerDvo, Team>>(
    initialValue: {},
    validator: _validate,
  );

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //
  //   // TODO: Improve it with update by id
  //   final players = await ref.watch(PlayersBloc.all.future);
  //   _players.updateValue({
  //     for (final player in players) player: Team.none,
  //   });
  // }

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

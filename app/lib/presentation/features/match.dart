import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/matches/dvo/match_dvo.dart';
import 'package:mek_gasol/features/matches/triggers/matches_trigger.dart';
import 'package:mek_gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/presentation/features/players.dart';
import 'package:mek_gasol/shared/form/form.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:mek_gasol/shared/form/form_validators.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/rivertion.dart';

class MatchFormBloc extends ListFieldBloc<dynamic> {
  final MatchDvo? match;

  final teamsFB = FieldBloc<Map<Team, List<PlayerDvo>>>(
    initialValue: {},
    validators: [_validateTeam],
  );

  final leftPointsFB = AdaptiveFieldBloc<int, String>(
    adapter: IntegerAdapter(),
    fieldBloc: FieldBloc(
      initialValue: '0',
    ),
    validators: [const IntegerValidator(min: 0)],
  );
  final rightPointsFB = AdaptiveFieldBloc<int, String>(
    adapter: IntegerAdapter(),
    fieldBloc: FieldBloc(
      initialValue: '0',
    ),
    validators: [const IntegerValidator(min: 0)],
  );

  MatchFormBloc({required this.match}) {
    teamsFB.updateValue({
      Team.left: match?.leftPlayers.asList() ?? const [],
      Team.right: match?.rightPlayers.asList() ?? const [],
    });
    leftPointsFB.updateValue(match?.leftPoints ?? 0);
    rightPointsFB.updateValue(match?.rightPoints ?? 0);

    addFieldBlocs([teamsFB, leftPointsFB, rightPointsFB]);
  }

  static Object? _validateTeam(Map<Team, List<PlayerDvo>> values) {
    final leftCount = values[Team.left]?.length ?? 0;
    final rightCount = values[Team.right]?.length ?? 0;

    if (leftCount < 1 && rightCount < 1) return 'Missing Left and Right';
    if (leftCount < 1) return 'Missing Left';
    if (rightCount < 1) return 'Missing Right';

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
            leftPlayers: teams[Team.left]!.toBuiltList(),
            rightPlayers: teams[Team.right]!.toBuiltList(),
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
        Hub.pop();
      }, orElse: (_) {
        //
      });
    });

    final form = Column(
      children: [
        Row(
          children: const [
            Expanded(child: Text('Left Team', textAlign: TextAlign.center)),
            Expanded(child: Text('Right Team', textAlign: TextAlign.center)),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextFieldBuilder(
                fieldBloc: formBloc.leftPointsFB.fieldBloc,
                type: const TextFieldType.numeric(),
              ),
            ),
            Expanded(
              child: TextFieldBuilder(
                fieldBloc: formBloc.rightPointsFB.fieldBloc,
                type: const TextFieldType.numeric(),
              ),
            ),
          ],
        ),
        CubitConsumer<FieldBlocState<Map<Team, List<PlayerDvo>>>>(
          bloc: formBloc.teamsFB,
          builder: (context, state, _) {
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

            final error = state.error;
            final teamsWithError = CupertinoFormRow(
              error: error != null ? Text('$error') : null,
              child: Column(
                children: [
                  teams,
                  if (leftTeam.isEmpty && rightTeam.isEmpty) const Text('Tap to choose Players'),
                ],
              ),
            );

            return GestureDetector(
              onTap: () async {
                final teams = await Hub.push<Map<Team, List<PlayerDvo>>>(const _TeamsScreen());
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

        final saveButton = CubitConsumer<ListFieldBlocState<dynamic>>(
          bloc: formBloc,
          builder: (context, state, _) {
            return CupertinoButton(
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

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Match'),
      ),
      child: SafeArea(
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
    validators: [_validate],
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

    if (leftCount < 1) return 'Missing Left';
    if (rightCount < 1) return 'Missing Right';

    return null;
  }

  void save() {
    final values = _players.state.value;
    final result = values.entries
        .groupListsBy((element) => element.value)
        .map((key, value) => MapEntry(key, value.map((e) => e.key).toList()));
    Hub.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final players = CubitConsumer<FieldBlocState<Map<PlayerDvo, Team>>>(
      bloc: _players,
      builder: (context, state, _) {
        final values = state.value;
        return Column(
          children: values.entries.map((e) {
            return CupertinoFormRow(
              prefix: Text(e.key.username),
              child: CupertinoSlidingSegmentedControl<Team>(
                groupValue: e.value,
                onValueChanged: (team) =>
                    _players.updateValue({...values, e.key: team ?? Team.none}),
                children: const {
                  Team.left: Text('Left'),
                  Team.none: Text('None'),
                  Team.right: Text('Right'),
                },
              ),
            );
          }).toList(),
        );
      },
    );

    final error = CubitConsumer<FieldBlocState<Map<PlayerDvo, Team>>>(
      bloc: _players,
      builder: (context, state, _) {
        final error = state.error;

        if (error == null) return const SizedBox.shrink();

        return Align(
          alignment: AlignmentDirectional.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 24.0),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: CupertinoColors.destructiveRed,
                fontWeight: FontWeight.w500,
              ),
              child: Text('$error'),
            ),
          ),
        );
      },
    );

    final buttonsBar = CubitConsumer<FieldBlocState<Map<PlayerDvo, Team>>>(
      bloc: _players,
      builder: (context, state, _) {
        return SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            onPressed: state.isValid ? save : null,
            child: const Text('Save'),
          ),
        );
      },
    );

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: players,
            ),
            error,
            buttonsBar,
          ],
        ),
      ),
    );
  }
}

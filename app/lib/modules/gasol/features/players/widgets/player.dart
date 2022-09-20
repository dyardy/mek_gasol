import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/players/triggers/players_trigger.dart';
import 'package:mek_gasol/shared/form/fields/field_text.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:rivertion/rivertion.dart';

class _SavePlayerParams {
  final String? playerId;
  final String username;

  const _SavePlayerParams({
    this.playerId,
    required this.username,
  });
}

abstract class PlayerBloc {
  static final save = MutationProvider.autoDispose<_SavePlayerParams, PlayerDvo>((ref) {
    return MutationBloc((params) async {
      return await ref.read(PlayersTrigger.instance).save(
            playerId: params.playerId,
            username: params.username,
          );
    }, onSuccess: (_, __) async {
      // await ref.maybeRefresh(PlayersBloc.all.future);
    });
  });

  static final delete = MutationProvider.autoDispose<PlayerDvo, void>((ref) {
    return MutationBloc((player) async {
      await ref.read(PlayersTrigger.instance).delete(player);
    }, onSuccess: (_, __) async {
      // await ref.maybeRefresh(PlayersBloc.all.future);
    });
  });
}

class PlayerScreen extends ConsumerStatefulWidget {
  final PlayerDvo? player;

  const PlayerScreen({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late final FieldBloc<String> _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = FieldBloc(initialValue: widget.player?.username ?? '');
  }

  @override
  void dispose() {
    _usernameController.close();
    super.dispose();
  }

  void save() {
    final args = _SavePlayerParams(
      playerId: widget.player?.id,
      username: _usernameController.state.value,
    );
    ref.read(PlayerBloc.save.bloc).maybeMutate(args);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;

    ref.listen<MutationState>(PlayerBloc.save, (previous, next) {
      next.maybeMap(success: (state) {
        context.hub.pop(state.data);
      }, orElse: (_) {
        // nothing
      });
    });

    ref.listen<MutationState>(PlayerBloc.delete, (previous, next) {
      next.maybeMap(success: (state) {
        context.hub.pop(null);
      }, orElse: (_) {
        // nothing
      });
    });

    Widget buildDeleteButton(PlayerDvo player) {
      return Consumer(
        builder: (context, ref, _) {
          final canDelete = ref.watch(PlayerBloc.delete.select((state) => !state.isMutating));

          return IconButton(
            onPressed:
                canDelete ? () => ref.read(PlayerBloc.delete.bloc).maybeMutate(player) : null,
            icon: const Icon(Icons.delete),
          );
        },
      );
    }

    final buttonBar = Consumer(
      builder: (context, ref, _) {
        final canSave = ref.watch(PlayerBloc.save.select((state) => !state.isMutating));
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSave ? save : null,
            child: const Text('Save'),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player?.username ?? 'Player'),
        actions: [
          if (player != null) buildDeleteButton(player),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FieldText(
                      fieldBloc: _usernameController,
                      converter: FieldConvert.text,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            buttonBar,
          ],
        ),
      ),
    );
  }
}

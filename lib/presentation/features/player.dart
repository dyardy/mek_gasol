import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/features/players/triggers/players_trigger.dart';
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
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.player?.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void save() {
    final args = _SavePlayerParams(
      playerId: widget.player?.id,
      username: _usernameController.text,
    );
    ref.read(PlayerBloc.save.bloc).maybeMutate(args);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;

    ref.listen<MutationState>(PlayerBloc.save, (previous, next) {
      next.maybeMap(success: (state) {
        Hub.pop(state.data);
      }, orElse: (_) {
        // nothing
      });
    });

    ref.listen<MutationState>(PlayerBloc.delete, (previous, next) {
      next.maybeMap(success: (state) {
        Hub.pop(null);
      }, orElse: (_) {
        // nothing
      });
    });

    Widget _buildDeleteButton(PlayerDvo player) {
      return Consumer(
        builder: (context, ref, _) {
          final canDelete = ref.watch(PlayerBloc.delete.select((state) => !state.isMutating));

          return CupertinoButton(
            onPressed:
                canDelete ? () => ref.read(PlayerBloc.delete.bloc).maybeMutate(player) : null,
            child: const Icon(CupertinoIcons.delete),
          );
        },
      );
    }

    final buttonBar = Consumer(
      builder: (context, ref, _) {
        final canSave = ref.watch(PlayerBloc.save.select((state) => !state.isMutating));
        return SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            onPressed: canSave ? save : null,
            child: Text('Save'),
          ),
        );
      },
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.player?.username ?? 'Player'),
        trailing: player != null ? _buildDeleteButton(player) : null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoTextField(
              controller: _usernameController,
              placeholder: 'Username',
            ),
            const Spacer(),
            buttonBar,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/players/triggers/players_trigger.dart';
import 'package:mek_gasol/shared/hub.dart';

class PlayerScreen extends StatefulWidget {
  final PlayerDvo? player;

  const PlayerScreen({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final FieldBloc<String> _usernameController;

  final _saveMb = MutationBloc();
  final _deleteMb = MutationBloc();

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
    _saveMb.handle(() async {
      return await get<PlayersTrigger>().save(
        playerId: widget.player?.id,
        username: _usernameController.state.value,
      );
    });
  }

  void _delete(PlayerDvo player) {
    _deleteMb.handle(() async {
      await get<PlayersTrigger>().delete(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget current = _build(context);
    current = BlocListener(
      bloc: _saveMb,
      listener: (context, state) => state.whenOrNull(success: (_) {
        context.hub.pop();
      }),
      child: current,
    );
    current = BlocListener(
      bloc: _deleteMb,
      listener: (context, state) => state.whenOrNull(success: (_) {
        context.hub.pop();
      }),
      child: current,
    );
    return current;
  }

  Widget _build(BuildContext context) {
    final player = widget.player;

    Widget buildDeleteButton(PlayerDvo player) {
      return ButtonBuilder(
        onPressed: () => _delete(player),
        mutationBlocs: [_saveMb, _deleteMb],
        builder: (context, onPressed) {
          return IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.delete),
          );
        },
      );
    }

    final buttonBar = ButtonBuilder(
      onPressed: save,
      mutationBlocs: [_saveMb, _deleteMb],
      builder: (context, onPressed) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
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

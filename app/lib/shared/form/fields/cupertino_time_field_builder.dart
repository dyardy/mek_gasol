import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pure_extensions/pure_extensions.dart';

@Deprecated('Classe non utilizzata')
class CupertinoTimeFieldBuilder extends StatelessWidget {
  final InputFieldBloc<DateTime, dynamic> inputFieldBloc;

  const CupertinoTimeFieldBuilder({
    Key? key,
    required this.inputFieldBloc,
  }) : super(key: key);

  Widget _buildPicker(BuildContext context) {
    return _Picker(
      initialDuration: Duration(
        hours: inputFieldBloc.value.hour,
        minutes: 0, // inputFieldBloc.value.minute,
      ),
    );
  }

  void _showPicker(BuildContext context) async {
    final duration = await showCupertinoModalPopup<Duration>(
      context: context,
      // anchorPoint: Offset(0.0, 0.0),
      builder: _buildPicker,
    );
    if (duration == null) return;
    inputFieldBloc.changeValue(inputFieldBloc.value.copyWith(
      hour: duration.hours,
      minute: duration.minutes,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFieldBlocBuilder<InputFieldBlocState<DateTime, dynamic>>(
      fieldBloc: inputFieldBloc,
      builder: (context, state, data) {
        return GestureDetector(
          onTap: () => _showPicker(context),
          child: Text('${state.value}'),
        );
      },
    );
  }
}

class _Picker extends StatefulWidget {
  final Duration initialDuration;

  const _Picker({
    Key? key,
    required this.initialDuration,
  }) : super(key: key);

  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _duration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(context, _duration),
                child: const Text('Select'),
              ),
            ],
          ),
          CupertinoTimerPicker(
            initialTimerDuration: widget.initialDuration,
            mode: CupertinoTimerPickerMode.hm,
            minuteInterval: 30,
            onTimerDurationChanged: (value) => _duration = value,
          ),
        ],
      ),
    );
  }
}

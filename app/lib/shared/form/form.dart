import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:mek_gasol/shared/form/form_utils.dart';

class TextFieldBuilder extends ConsumerStatefulWidget {
  final FieldBloc<String> fieldBloc;
  final TextFieldType type;
  final String? placeholderText;
  final Widget? helper;

  const TextFieldBuilder({
    Key? key,
    required this.fieldBloc,
    this.type = const TextFieldType(),
    this.placeholderText,
    this.helper,
  }) : super(key: key);

  @override
  ConsumerState<TextFieldBuilder> createState() => _TextFieldBuilderState();
}

class _TextFieldBuilderState extends ConsumerState<TextFieldBuilder> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.fieldBloc.state.value);
  }

  @override
  void didUpdateWidget(covariant TextFieldBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fieldBloc != oldWidget.fieldBloc) {
      _controller.dispose();
      _controller = TextEditingController(text: widget.fieldBloc.state.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FieldBlocState<String>>(
      bloc: widget.fieldBloc,
      listener: (context, state) {
        if (_controller.text == state.value) return;
        _controller.text = state.value;
      },
      builder: (context, state) {
        final field = CupertinoTextField(
          controller: _controller,
          placeholder: widget.placeholderText,
          onChanged: widget.fieldBloc.changeValue,
          keyboardType: widget.type.getKeyboardType(),
          inputFormatters: widget.type.getInputFormatters(),
        );

        return CupertinoFormRow(
          helper: widget.helper,
          error: state.isInvalid ? Text('${state.errors.first}') : null,
          child: field,
        );
      },
    );
  }
}

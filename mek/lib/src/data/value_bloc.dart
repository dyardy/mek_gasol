import 'package:bloc/bloc.dart';

class ValueBloc<T> extends Cubit<T> {
  ValueBloc(super.initialState);

  @override
  void emit(T state) => super.emit(state);
}

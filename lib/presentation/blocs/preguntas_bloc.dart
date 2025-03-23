import 'package:flutter_bloc/flutter_bloc.dart';

class  PreguntasBloc extends Cubit<String>{


  PreguntasBloc(super.initialState);

  void changeString(String value) {
    if (value.isNotEmpty) {
      emit(value);
    } else {
      emit('');
    }
  }
}
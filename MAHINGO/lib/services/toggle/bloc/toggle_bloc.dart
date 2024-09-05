import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'toggle_event.dart';
part 'toggle_state.dart';


class ToggleBloc extends Bloc<ToggleEvent, ToggleState> {
  ToggleBloc() : super(const ToggleState()) {
    on<ToggleFirstPasswordVisibility>((event, emit) {
      emit(state.copyWith(
        isFirstPasswordObscured: !state.isFirstPasswordObscured,
      ));
    });

    on<ToggleSecondPasswordVisibility>((event, emit) {
      emit(state.copyWith(
        isSecondPasswordObscured: !state.isSecondPasswordObscured,
      ));
    });
  }
}


// class ToggleBloc extends Bloc<ToggleEvent, ToggleState> {
//   ToggleBloc() : super(const ToggleInitialState(true)) {
//     on<ToggleSubmitEvent>((event, emit) {
//       emit(ToggleInitialState(!(state as ToggleInitialState).isOn));
//     });
//   }

// }

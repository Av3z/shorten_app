import 'package:flutter_bloc/flutter_bloc.dart';

part 'darkmode_event.dart';
part 'darkmode_state.dart';

class DarkModeBloc extends Bloc<DarkModeEvent, DarkModeState> {
  DarkModeBloc() : super(IsLightModeState()) {
    on<ChangeDarkMode>(
      (event, emit) {
        if (event.isDarkMode == true) {
          return emit(IsDarkModeState());
        }
        return emit(IsLightModeState());
      },
    );
  }
}

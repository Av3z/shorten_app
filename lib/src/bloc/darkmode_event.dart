part of 'darkmode_bloc.dart';

sealed class DarkModeEvent {}

final class ChangeDarkMode extends DarkModeEvent {
  final bool isDarkMode;
  ChangeDarkMode(this.isDarkMode);
}

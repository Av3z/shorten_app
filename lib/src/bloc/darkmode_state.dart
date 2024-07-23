part of 'darkmode_bloc.dart';

sealed class DarkModeState {}

final class IsDarkModeState extends DarkModeState {}

final class IsLightModeState extends DarkModeState {}

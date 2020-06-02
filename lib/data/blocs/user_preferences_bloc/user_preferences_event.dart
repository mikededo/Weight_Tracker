part of 'user_preferences_bloc.dart';

abstract class UserPreferencesEvent extends Equatable {
  const UserPreferencesEvent();

  @override
  List<Object> get props => [];
}

class UserPreferencesLoadPreferences extends UserPreferencesEvent {}

class UserPreferencesAddPreferences extends UserPreferencesEvent {
  final UserData preferences;

  const UserPreferencesAddPreferences(this.preferences);

  @override
  List<Object> get props => [preferences];

  @override
  String toString() => 'PrefsAdded {data: $preferences}';
}

class UserPreferencesUpdatePreference extends UserPreferencesEvent {
  final String prefKey;
  final dynamic prefValue;

  const UserPreferencesUpdatePreference(this.prefKey, this.prefValue);

  @override
  List<Object> get props => [prefKey, prefValue];

  @override
  String toString() => 'PrefsUpdated {data: {$prefKey, $prefValue}';
}

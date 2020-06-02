import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_tracker/data/database/user_shared_preferences.dart';
import 'package:weight_tracker/data/models/user_data.dart';
import 'package:weight_tracker/util/pair.dart';

part 'user_preferences_event.dart';

class UserPreferencesBloc extends Bloc<UserPreferencesEvent, UserData> {
  @override
  UserData get initialState => UserData.emptyData();

  @override
  Stream<UserData> mapEventToState(
    UserPreferencesEvent event,
  ) async* {
    if (event is UserPreferencesLoadPreferences) {
      yield* _mapLoadPreferencesToState();
    } else if (event is UserPreferencesAddPreferences) {
      yield* _mapAddPreferencesToState(event);
    } else if (event is UserPreferencesUpdatePreference) {
      yield* _mapUpdatePreferenceToState(event);
    }
  }

  Stream<UserData> _mapLoadPreferencesToState() async* {
    try {
      yield await UserSharedPreferences.loadPreferences();
    } catch (_) {
      yield UserData.emptyData();
    }
  }

  Stream<UserData> _mapAddPreferencesToState(
    UserPreferencesAddPreferences event,
  ) async* {
    try {
      await UserSharedPreferences.addPreferences(event.preferences);
      yield await UserSharedPreferences.loadPreferences();
    } catch (_) {
      yield UserData.emptyData();
    }
  }

  Stream<UserData> _mapUpdatePreferenceToState(
    UserPreferencesUpdatePreference event,
  ) async* {
    try {
      await UserSharedPreferences.updatePreference(
        Pair<String, dynamic>(
          first: event.prefKey,
          second: event.prefValue,
        ),
      );
      yield await UserSharedPreferences.loadPreferences();
    } catch (_) {
      yield UserData.emptyData();
    }
  }
}

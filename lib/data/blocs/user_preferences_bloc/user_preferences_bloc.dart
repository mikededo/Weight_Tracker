import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_tracker/util/util.dart';
import '../../database/user_shared_preferences.dart';
import '../../models/user_data.dart';
import '../../../util/pair.dart';

part 'user_preferences_event.dart';

class UserPreferencesBloc extends Bloc<UserPreferencesEvent, UserData> {
  UserPreferencesBloc() : super(UserData.emptyData());

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
    } else if (event is UserPreferencesAddUnit) {
      yield* _mapAddUnitToState(event);
    }
  }

  Stream<UserData> _mapLoadPreferencesToState() async* {
    UserData lastState = state;
    try {
      yield await UserSharedPreferences.loadPreferences();
    } catch (_) {
      yield lastState;
    }
  }

  Stream<UserData> _mapAddPreferencesToState(
    UserPreferencesAddPreferences event,
  ) async* {
    UserData lastState = state;
    try {
      await UserSharedPreferences.addPreferences(event.preferences);
      // Check if there are no errors
      UserData temp = await UserSharedPreferences.loadPreferences();
      yield temp;
    } catch (_) {
      yield lastState;
    }
  }

  Stream<UserData> _mapUpdatePreferenceToState(
    UserPreferencesUpdatePreference event,
  ) async* {
    UserData lastState = state;
    try {
      await UserSharedPreferences.updatePreference(
        Pair<String, dynamic>(
          first: event.prefKey,
          second: event.prefValue,
        ),
      );
      yield await UserSharedPreferences.loadPreferences();
    } catch (_) {
      yield lastState;
    }
  }

  Stream<UserData> _mapAddUnitToState(UserPreferencesAddUnit event) async* {
    UserData lastState = state;
    try {
      await UserSharedPreferences.updatePreference(
        Pair<String, Unit>(
          first: UserData.UD_UNIT,
          second: event.unit,
        ),
      );
      yield await UserSharedPreferences.loadPreferences();
    } catch (_) {
      yield lastState;
    }
  }
}

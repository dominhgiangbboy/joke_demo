import 'package:demo_for_vnext/core/enum.dart';
import 'package:demo_for_vnext/core/http_client.dart';
import 'package:demo_for_vnext/data/request_model_for_jokes.dart';
import 'package:demo_for_vnext/data/response_model_for_jokes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'joke_event.dart';
import 'joke_state.dart';

export 'joke_event.dart';
export 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final HttpClient httpClient;
  JokeBloc(this.httpClient) : super(JokeState.initialJokeState()) {
    on<JokeEventSubmit>(_onSubmit);
    on<ResetJokeSubmit>(_onReset);
    on<AddCategoryJokeEvent>(_onAddCategory);
    on<RemoveCategoryJokeEvent>(_onRemoveCategory);
    on<AddBlacklistFlagsJokeEvent>(_onAddBlacklistFlags);
    on<RemoveBlacklistFlagsJokeEvent>(_onRemoveBlacklistFlags);
  }

  Future _onRemoveBlacklistFlags(RemoveBlacklistFlagsJokeEvent event, Emitter<JokeState> emit) async {
    List<String> currentList = state.blacklistFlags.toList();
    emit(state.copyWith(blacklistFlags: currentList..remove(event.blacklistFlags)));
  }

  Future _onAddBlacklistFlags(AddBlacklistFlagsJokeEvent event, Emitter<JokeState> emit) async {
    List<String> currentList = state.blacklistFlags.toList();
    emit(state.copyWith(blacklistFlags: currentList..add(event.blacklistFlags)));
  }

  Future _onRemoveCategory(RemoveCategoryJokeEvent event, Emitter<JokeState> emit) async {
    List<String> currentList = state.categories.toList();
    emit(state.copyWith(categories: currentList..remove(event.category)));
  }

  Future _onAddCategory(AddCategoryJokeEvent event, Emitter<JokeState> emit) async {
    List<String> currentList = state.categories.toList();
    emit(state.copyWith(categories: currentList..add(event.category)));
  }

  Future _onReset(ResetJokeSubmit event, Emitter<JokeState> emit) async {
    emit(JokeState.initialJokeState());
  }

  Future _onSubmit(JokeEventSubmit event, Emitter<JokeState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final RequestJokeModel requestJokeModel = RequestJokeModel(
        category: state.categories,
        blacklistFlags: state.blacklistFlags,
        contains: event.searchString ?? '',
      );
      final dynamic response = await httpClient.get('joke${requestJokeModel.convertToQuery()}');
      if (response['error'] != null && response['error'] == true) {
        emit(state.copyWith(status: BlocStatus.error, errorMessage: response.data['message']));
        return;
      }
      final ResponsModelForJokes responseMapped = ResponsModelForJokes.fromMap(response);
      emit(state.copyWith(
        setupJoke: responseMapped.setup.isEmpty ? responseMapped.joke : responseMapped.setup,
        deliveryJoke: responseMapped.delivery,
        status: BlocStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}

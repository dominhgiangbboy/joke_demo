import 'package:demo_for_vnext/core/enum.dart';
import 'package:demo_for_vnext/core/http_client.dart';
import 'package:demo_for_vnext/data/request_model_for_jokes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'joke_event.dart';
import 'joke_state.dart';

export 'joke_event.dart';
export 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final HttpClient httpClient;
  JokeBloc(this.httpClient) : super(const JokeState(status: BlocStatus.initial)) {
    on<JokeEventSubmit>(_onSubmit);
    on<ResetJokeSubmit>(_onReset);
  }
  Future _onReset(ResetJokeSubmit event, Emitter<JokeState> emit) async {
    emit(const JokeState(status: BlocStatus.initial));
  }

  Future _onSubmit(JokeEventSubmit event, Emitter<JokeState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      RequestJokeModel requestJokeModel = RequestJokeModel(contains: event.searchString?? '', category: category, blacklistFlags: blacklistFlags),
      await httpClient.post('/test_url', event.joke.toMap());
      emit(state.copyWith(status: BlocStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}

import 'package:bloc_test/bloc_test.dart';
import 'package:demo_for_vnext/core/enum.dart';
import 'package:demo_for_vnext/core/http_client.dart';
import 'package:demo_for_vnext/data/joke.dart';
import 'package:demo_for_vnext/features/joke_feature/blocs/joke_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<HttpClient>()])
import 'joke_bloc_test.mocks.dart';

final JokeEntity jokeEntity = JokeEntity(
  searchString: 'test',
  category: JokeCategory.dark,
  blacklist: BlackList.nsfw,
);
final JokeEntity errorJokeEntity = JokeEntity(
  searchString: 'test error',
  category: JokeCategory.dark,
  blacklist: BlackList.nsfw,
);
void main() {
  when(MockHttpClient().post('/test_url', jokeEntity.toMap())).thenAnswer((_) async => 'Success');
  when(MockHttpClient().post('/test_url', errorJokeEntity.toMap())).thenThrow((_) async => 'Success');
  group("Testing bloc state and event", () {
    blocTest(
      'emits [] when nothing is added',
      build: () => JokeBloc(MockHttpClient()),
      expect: () => [],
    );

    blocTest('emits [JokeState(status: BlocStatus.loading), JokeState(status: BlocStatus.loaded)] when JokeEventSubmit is added',
        build: () => JokeBloc(MockHttpClient()),
        act: (bloc) => bloc.add(JokeEventSubmit(joke: jokeEntity)),
        expect: () => [
              const JokeState(status: BlocStatus.loading),
              const JokeState(status: BlocStatus.loaded),
            ]);
    blocTest('emits [JokeState(status: BlocStatus.loading), JokeState(status: BlocStatus.error)] when JokeEventSubmit is added But error from API',
        build: () => JokeBloc(MockHttpClient()),
        act: (bloc) => bloc.add(JokeEventSubmit(joke: errorJokeEntity)),
        expect: () => [
              const JokeState(status: BlocStatus.loading),
              const JokeState(status: BlocStatus.error),
            ]);
  });
}

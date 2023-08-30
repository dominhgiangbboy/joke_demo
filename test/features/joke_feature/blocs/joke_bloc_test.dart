import 'package:bloc_test/bloc_test.dart';
import 'package:demo_for_vnext/core/enum.dart';
import 'package:demo_for_vnext/core/http_client.dart';
import 'package:demo_for_vnext/core/url_and_endpoint.dart';
import 'package:demo_for_vnext/data/request_model_for_jokes.dart';
import 'package:demo_for_vnext/features/joke_feature/blocs/joke_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<HttpClient>()])
import 'joke_bloc_test.mocks.dart';

final RequestJokeModel jokeModelMockSuccess = RequestJokeModel(
  category: ['Misc'],
  blacklistFlags: ['nsfw'],
  contains: 'test',
);
final RequestJokeModel jokeModelMockFailure = RequestJokeModel(
  category: ['Misc'],
  blacklistFlags: ['nsfw'],
  contains: 'fail',
);

const Map<String, dynamic> mockSuccessReturnJoke = {
  "error": false,
  "category": "Misc",
  "type": "twopart",
  "setup": "What do you call a cow with no legs?",
  "delivery": "Ground beef!",
  "flags": {"nsfw": true, "religious": false, "political": false, "racist": false, "sexist": false, "explicit": false},
  "id": 115,
  "safe": true,
  "lang": "en"
};

const Map<String, dynamic> mockErrorReturnJoke = {
  "error": true,
  "internalError": false,
  "code": 106,
  "message": "No matching joke found",
  "causedBy": ["No jokes were found that match your provided filter(s)."],
  "additionalInfo": "Error while finalizing joke filtering: No jokes were found that match your provided filter(s).",
  "timestamp": 1693410407370
};
void main() {
  final MockHttpClient mockHttpClient = MockHttpClient();
  final String querySuccess = jokeModelMockSuccess.convertToQuery();
  final String queryFailure = jokeModelMockFailure.convertToQuery();
  when(mockHttpClient.get(
    '$jokeEndpoint$querySuccess',
  )).thenAnswer((_) async => mockSuccessReturnJoke);
  when(mockHttpClient.get(
    '$jokeEndpoint$queryFailure',
  )).thenThrow((_) async => mockErrorReturnJoke);
  when(mockHttpClient.get(
    jokeEndpoint,
  )).thenThrow((_) async => 'Success');
  group("Testing bloc state and event", () {
    blocTest(
      'emits [] when nothing is added',
      build: () => JokeBloc(MockHttpClient()),
      expect: () => [],
    );
    blocTest(
      'Test add catgories',
      build: () => JokeBloc(MockHttpClient()),
      act: (bloc) => bloc.add(const AddCategoryJokeEvent(category: 'Misc')),
      expect: () => [
        JokeState.initialJokeState().copyWith(categories: ['Misc']),
      ],
    );
    blocTest(
      'Test remove catgories',
      build: () => JokeBloc(MockHttpClient()),
      act: (bloc) => bloc
        ..add(const AddCategoryJokeEvent(category: 'Misc'))
        ..add(const RemoveCategoryJokeEvent(category: 'Misc')),
      expect: () => [
        JokeState.initialJokeState().copyWith(categories: ['Misc']),
        JokeState.initialJokeState(),
      ],
    );
    blocTest(
      'Test remove BlacklistFlags',
      build: () => JokeBloc(MockHttpClient()),
      act: (bloc) => bloc.add(const AddBlacklistFlagsJokeEvent(blacklistFlags: 'nsfw')),
      expect: () => [
        JokeState.initialJokeState().copyWith(blacklistFlags: ['nsfw']),
      ],
    );
    blocTest(
      'Test remove BlacklistFlags',
      build: () => JokeBloc(MockHttpClient()),
      act: (bloc) => bloc
        ..add(const AddBlacklistFlagsJokeEvent(blacklistFlags: 'nsfw'))
        ..add(const RemoveBlacklistFlagsJokeEvent(blacklistFlags: 'nsfw')),
      expect: () => [
        JokeState.initialJokeState().copyWith(blacklistFlags: ['nsfw']),
        JokeState.initialJokeState(),
      ],
    );
    blocTest(
      'Test reset',
      build: () => JokeBloc(MockHttpClient()),
      act: (bloc) => bloc
        ..add(const AddBlacklistFlagsJokeEvent(blacklistFlags: 'nsfw'))
        ..add(const ResetJokeSubmit()),
      expect: () => [
        JokeState.initialJokeState().copyWith(blacklistFlags: ['nsfw']),
        JokeState.initialJokeState(),
      ],
    );
    final JokeState addedAllCheckBoxState = JokeState.initialJokeState().copyWith(blacklistFlags: ['nsfw'], categories: ['Misc']);
    blocTest(
      'Testing sumiting event found joke',
      build: () => JokeBloc(mockHttpClient),
      act: (bloc) => bloc
        ..add(AddBlacklistFlagsJokeEvent(blacklistFlags: jokeModelMockSuccess.blacklistFlags.first))
        ..add(AddCategoryJokeEvent(category: jokeModelMockSuccess.category.first))
        ..add(JokeEventSubmit(
          searchString: jokeModelMockSuccess.contains,
        )),
      expect: () => [
        JokeState.initialJokeState().copyWith(blacklistFlags: ['nsfw']),
        addedAllCheckBoxState,
        addedAllCheckBoxState.copyWith(status: BlocStatus.loading),
        addedAllCheckBoxState.copyWith(status: BlocStatus.loaded, setupJoke: mockSuccessReturnJoke['setup'], deliveryJoke: mockSuccessReturnJoke['delivery']),
      ],
    );

    blocTest(
      'Testing sumiting event error can not find joke',
      build: () => JokeBloc(mockHttpClient),
      act: (bloc) => bloc
        ..add(AddBlacklistFlagsJokeEvent(blacklistFlags: jokeModelMockFailure.blacklistFlags.first))
        ..add(AddCategoryJokeEvent(category: jokeModelMockFailure.category.first))
        ..add(JokeEventSubmit(
          searchString: jokeModelMockFailure.contains,
        )),
      expect: () => [
        JokeState.initialJokeState().copyWith(blacklistFlags: ['nsfw']),
        addedAllCheckBoxState,
        addedAllCheckBoxState.copyWith(status: BlocStatus.loading),
        addedAllCheckBoxState.copyWith(status: BlocStatus.error, errorMessage: mockErrorReturnJoke['message']),
      ],
    );

    blocTest(
      'Testing sumiting event wrong format error',
      build: () => JokeBloc(mockHttpClient),
      act: (bloc) => bloc
        ..add(AddBlacklistFlagsJokeEvent(blacklistFlags: jokeModelMockFailure.blacklistFlags.first))
        ..add(AddCategoryJokeEvent(category: jokeModelMockFailure.category.first))
        ..add(JokeEventSubmit(
          searchString: jokeModelMockFailure.contains,
        )),
      expect: () => [
        JokeState.initialJokeState().copyWith(blacklistFlags: ['nsfw']),
        addedAllCheckBoxState,
        addedAllCheckBoxState.copyWith(status: BlocStatus.loading),
        addedAllCheckBoxState.copyWith(status: BlocStatus.error),
      ],
    );
  });
}

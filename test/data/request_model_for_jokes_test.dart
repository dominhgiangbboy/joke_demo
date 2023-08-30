import 'package:demo_for_vnext/data/request_model_for_jokes.dart';
import 'package:flutter_test/flutter_test.dart';

final RequestJokeModel jokeModelMockSuccess = RequestJokeModel(
  category: ['Misc'],
  blacklistFlags: ['nsfw'],
  contains: 'test',
);
void main() {
  group("Test query creation from model", () {
    test("Full query", () {
      expect(
        jokeModelMockSuccess.convertToQuery(),
        '/Misc?contains=test&blacklistFlags=nsfw',
      );
    });

    test("Full without blackList", () {
      expect(
        jokeModelMockSuccess.copyWith(blacklistFlags: []).convertToQuery(),
        '/Misc?contains=test',
      );
    });

    test("Full without searchString", () {
      expect(
        jokeModelMockSuccess.copyWith(contains: "").convertToQuery(),
        '/Misc?blacklistFlags=nsfw',
      );
    });

    test("Full without searchString and blackList", () {
      expect(
        jokeModelMockSuccess.copyWith(contains: "", blacklistFlags: []).convertToQuery(),
        '/Misc',
      );
    });
    test("Without all params", () {
      expect(
        jokeModelMockSuccess.copyWith(category: [], contains: "", blacklistFlags: []).convertToQuery(),
        '/Any',
      );
    });
    test("Without Categories", () {
      expect(
          jokeModelMockSuccess.copyWith(
            category: [],
          ).convertToQuery(),
          '/Any?contains=test&blacklistFlags=nsfw');
    });
    test("Multiple params categories", () {
      expect(
          jokeModelMockSuccess.copyWith(
            category: [
              'Misc',
              'Programming',
            ],
          ).convertToQuery(),
          '/Misc,Programming?contains=test&blacklistFlags=nsfw');
    });
  });
}

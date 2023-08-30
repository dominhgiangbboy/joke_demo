import 'package:demo_for_vnext/core/enum.dart';

class JokeEntity {
  final String searchString;
  final JokeCategory category;
  final BlackList blacklist;
  JokeEntity({
    required this.searchString,
    required this.category,
    required this.blacklist,
  });

  JokeEntity copyWith({
    String? searchString,
    JokeCategory? category,
    BlackList? blacklist,
  }) {
    return JokeEntity(
      searchString: searchString ?? this.searchString,
      category: category ?? this.category,
      blacklist: blacklist ?? this.blacklist,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'searchString': searchString,
      'category': category.toString(),
      'blacklist': blacklist.toString(),
    };
  }
}

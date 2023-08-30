class RequestJokeModel {
  final String contains;
  final List<String> category;
  final List<String> blacklistFlags;
  RequestJokeModel({
    required this.contains,
    required this.category,
    required this.blacklistFlags,
  });
  String convertToQuery() {
    String query = '/';
    if (category.isNotEmpty) {
      query += '${category.join(',').trim()}?';
    } else {
      query += 'Any?';
    }
    if (contains.isNotEmpty) {
      query += 'contains=${contains.trim()}&';
    }

    if (blacklistFlags.isNotEmpty) {
      query += 'blacklistFlags=${blacklistFlags.join(',').trim()}&';
    }
    return query.substring(0, query.length - 1);
  }

  RequestJokeModel copyWith({
    String? contains,
    List<String>? category,
    List<String>? blacklistFlags,
  }) {
    return RequestJokeModel(
      contains: contains ?? this.contains,
      category: category ?? this.category,
      blacklistFlags: blacklistFlags ?? this.blacklistFlags,
    );
  }
}

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
      query += '${category.join(',').trim()}&';
    } else {
      query += 'Any&';
    }
    if (contains.isNotEmpty) {
      query += 'contains=${contains.trim()}&';
    }

    if (blacklistFlags.isNotEmpty) {
      query += 'blacklistFlags=${blacklistFlags.join(',').trim()}&';
    }
    return query;
  }
}

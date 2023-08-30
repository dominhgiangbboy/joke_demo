import 'dart:convert';

class ResponsModelForJokes {
  final bool error;
  final String category;
  final String type;
  final String setup;
  final String delivery;
  final Flags flags;
  final int id;
  final bool safe;
  final String lang;
  final String joke;
  ResponsModelForJokes({
    required this.error,
    required this.category,
    required this.type,
    required this.setup,
    required this.delivery,
    required this.flags,
    required this.id,
    required this.safe,
    required this.lang,
    required this.joke,
  });

  Map<String, dynamic> toMap() {
    return {
      'error': error,
      'category': category,
      'type': type,
      'setup': setup,
      'delivery': delivery,
      'flags': flags.toMap(),
      'id': id,
      'safe': safe,
      'lang': lang,
      'joke': joke,
    };
  }

  factory ResponsModelForJokes.fromMap(Map<String, dynamic> map) {
    return ResponsModelForJokes(
      error: map['error'] ?? false,
      category: map['category'] ?? '',
      type: map['type'] ?? '',
      setup: map['setup'] ?? '',
      delivery: map['delivery'] ?? '',
      flags: Flags.fromMap(map['flags']),
      id: map['id']?.toInt() ?? 0,
      safe: map['safe'] ?? false,
      lang: map['lang'] ?? '',
      joke: map['joke'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponsModelForJokes.fromJson(String source) => ResponsModelForJokes.fromMap(json.decode(source));
}

class Flags {
  final bool nsfw;
  final bool religious;
  final bool political;
  final bool racist;
  final bool sexist;
  final bool explicit;
  Flags({
    required this.nsfw,
    required this.religious,
    required this.political,
    required this.racist,
    required this.sexist,
    required this.explicit,
  });

  Map<String, dynamic> toMap() {
    return {
      'nsfw': nsfw,
      'religious': religious,
      'political': political,
      'racist': racist,
      'sexist': sexist,
      'explicit': explicit,
    };
  }

  factory Flags.fromMap(Map<String, dynamic> map) {
    return Flags(
      nsfw: map['nsfw'] ?? false,
      religious: map['religious'] ?? false,
      political: map['political'] ?? false,
      racist: map['racist'] ?? false,
      sexist: map['sexist'] ?? false,
      explicit: map['explicit'] ?? false,
    );
  }
}

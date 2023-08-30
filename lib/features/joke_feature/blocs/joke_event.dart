import 'package:equatable/equatable.dart';

class JokeEvent extends Equatable {
  const JokeEvent();

  @override
  List<Object> get props => [];
}

class ResetJokeSubmit extends JokeEvent {
  const ResetJokeSubmit();
}

class AddCategoryJokeEvent extends JokeEvent {
  final String category;
  const AddCategoryJokeEvent({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class RemoveCategoryJokeEvent extends JokeEvent {
  final String category;
  const RemoveCategoryJokeEvent({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class AddBlacklistFlagsJokeEvent extends JokeEvent {
  final String blacklistFlags;
  const AddBlacklistFlagsJokeEvent({
    required this.blacklistFlags,
  });

  @override
  List<Object> get props => [blacklistFlags];
}

class RemoveBlacklistFlagsJokeEvent extends JokeEvent {
  final String blacklistFlags;
  const RemoveBlacklistFlagsJokeEvent({
    required this.blacklistFlags,
  });

  @override
  List<Object> get props => [blacklistFlags];
}

class JokeEventSubmit extends JokeEvent {
  final String? searchString;
  const JokeEventSubmit({
    this.searchString,
  });

  @override
  List<Object> get props => [searchString ?? ''];
}

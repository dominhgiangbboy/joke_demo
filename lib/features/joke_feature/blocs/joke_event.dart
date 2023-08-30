import 'package:equatable/equatable.dart';

class JokeEvent extends Equatable {
  const JokeEvent();

  @override
  List<Object> get props => [];
}

class ResetJokeSubmit extends JokeEvent {
  const ResetJokeSubmit();
}

class JokeEventSubmit extends JokeEvent {
  final String? searchString;
  const JokeEventSubmit({
    this.searchString,
  });

  @override
  List<Object> get props => [searchString ?? ''];
}

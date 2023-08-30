import 'package:demo_for_vnext/data/joke.dart';
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
  final JokeEntity joke;

  const JokeEventSubmit({
    required this.joke,
  });

  @override
  List<Object> get props => [joke];
}

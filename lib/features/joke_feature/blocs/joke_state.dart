import 'package:demo_for_vnext/core/enum.dart';
import 'package:equatable/equatable.dart';

class JokeState extends Equatable {
  final BlocStatus status;
  const JokeState({
    required this.status,
  });

  JokeState copyWith({
    BlocStatus? status,
  }) {
    return JokeState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}

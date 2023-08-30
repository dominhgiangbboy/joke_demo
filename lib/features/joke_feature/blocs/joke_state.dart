import 'package:equatable/equatable.dart';

import 'package:demo_for_vnext/core/enum.dart';

class JokeState extends Equatable {
  final BlocStatus status;
  final List<String> categories;
  final List<String> blacklistFlags;
  final String setupJoke;
  final String deliveryJoke;
  final String? errorMessage;
  const JokeState({
    required this.status,
    required this.categories,
    required this.blacklistFlags,
    required this.setupJoke,
    required this.deliveryJoke,
    this.errorMessage,
  });
  factory JokeState.initialJokeState() => const JokeState(
        status: BlocStatus.initial,
        categories: [],
        blacklistFlags: [],
        setupJoke: '',
        deliveryJoke: '',
      );
  @override
  List<Object?> get props => [status, categories, blacklistFlags];

  JokeState copyWith({
    BlocStatus? status,
    List<String>? categories,
    List<String>? blacklistFlags,
    String? setupJoke,
    String? deliveryJoke,
    String? errorMessage,
  }) {
    return JokeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      blacklistFlags: blacklistFlags ?? this.blacklistFlags,
      setupJoke: setupJoke ?? this.setupJoke,
      deliveryJoke: deliveryJoke ?? this.deliveryJoke,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

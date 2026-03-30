part of 'create_prompt_bloc.dart';

@immutable
sealed class PromptState {}

final class PromptInitialState extends PromptState {
  final String imageUrl;
  PromptInitialState({required this.imageUrl});
}

final class PromptLoadState extends PromptState {}

final class PrompErrorState extends PromptState {}

final class PrompSuceessState extends PromptState {
  final String imageUrl;
  PrompSuceessState({required this.imageUrl});
}

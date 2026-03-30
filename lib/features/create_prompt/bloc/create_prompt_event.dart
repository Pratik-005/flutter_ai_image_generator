part of 'create_prompt_bloc.dart';

@immutable
sealed class CreatePromptEvent {}

class PromptInitialEvent extends CreatePromptEvent {}

class PromptEnteredEvent extends CreatePromptEvent {
  final String prompt;
  PromptEnteredEvent(this.prompt);
}

import 'dart:async';
import 'package:flutter/widgets.dart' show immutable;
import 'package:flutter_ai_image_generator/features/create_prompt/repo/prompt_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'create_prompt_event.dart';
part 'create_prompt_state.dart';

class CreatePromptBloc extends Bloc<CreatePromptEvent, PromptState> {
  CreatePromptBloc() : super(PromptInitialState(imageUrl: 'assets/file.png')) {
    on<PromptEnteredEvent>(promptEnteredEvent);
    on<PromptInitialEvent>(promptInitialEvent);
  }

  FutureOr<void> promptEnteredEvent(
    PromptEnteredEvent event,
    Emitter<PromptState> emit,
  ) async {
    emit(PromptLoadState());
    try {
      String url = await PromptRepo.generateImage(event.prompt);
      emit(PrompSuceessState(imageUrl: url));
    } catch (e) {
      emit(PrompErrorState());
    }
  }

  void promptInitialEvent(
    PromptInitialEvent event,
    Emitter<PromptState> emit,
  ) async {
    try {
      emit(PromptInitialState(imageUrl: 'assets/file.png'));
    } catch (e) {
      emit(PrompErrorState());
    }
  }
}

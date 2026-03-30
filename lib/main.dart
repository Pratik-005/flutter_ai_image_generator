import 'package:flutter/material.dart';
import 'package:flutter_ai_image_generator/features/create_prompt/bloc/create_prompt_bloc.dart';
import 'package:flutter_ai_image_generator/features/create_prompt/ui/create_prompt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  runApp(const MyApp());
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreatePromptBloc>(create: (context) => CreatePromptBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey.shade900,
        ),
        builder: (context, child) => SafeArea(child: child!),
        home: CreatePrompt(),
      ),
    );
  }
}

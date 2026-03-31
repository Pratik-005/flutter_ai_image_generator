import 'package:flutter/material.dart';
import 'package:flutter_ai_image_generator/features/create_prompt/bloc/create_prompt_bloc.dart';
import 'package:flutter_ai_image_generator/features/create_prompt/ui/view_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreatePrompt extends StatefulWidget {
  const CreatePrompt({super.key});

  @override
  State<CreatePrompt> createState() => _CreatePromptState();
}

class _CreatePromptState extends State<CreatePrompt> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    context.read<CreatePromptBloc>().add(PromptInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Generator', style: TextStyle(fontSize: 18)),
        leading: Icon(Icons.image),
        titleSpacing: 0,
        actions: [],
      ),
      body: BlocConsumer<CreatePromptBloc, PromptState>(
        listener: (context, state) => {
          if (state.runtimeType == PrompSuceessState)
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return ViewImage(
                      imageUrl: (state as PrompSuceessState).imageUrl,
                    );
                  },
                ),
              ),
            },
        },

        builder: (context, state) {
          switch (state.runtimeType) {
            case PromptLoadState:
              const spinkit = SpinKitFadingCube(
                color: Colors.white,
                size: 80.0,
              );
              return Center(child: spinkit);

            case PrompErrorState:
              return Center(child: Text("Something went wrong"));

            case PromptInitialState:
              final initialState = state as PromptInitialState;
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade800,
                        child: Image.asset(
                          initialState.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Divider(),
                    Container(
                      height: 250,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter your prompt',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),

                          TextField(
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(
                                    255,
                                    75,
                                    128,
                                    220,
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: double.maxFinite,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<CreatePromptBloc>().add(
                                  PromptEnteredEvent(controller.text),
                                );
                              },
                              label: Text('Generate Image'),
                              icon: Icon(Icons.generating_tokens),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}

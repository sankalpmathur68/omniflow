import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omniflow/cubits/taskcubit.dart';
import 'package:omniflow/screens/loading.dart';
import 'package:omniflow/screens/menuScreen.dart';
import 'package:omniflow/screens/pdfEditor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omani Flow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => TaskCubit(),
        child:
            BlocBuilder<TaskCubit, TaskCubitState>(builder: (context, state) {
          if (state is TaskCubitLoading) {
            return loading();
          }
          return TaskMenu();
        }),
      ),
    );
  }
}

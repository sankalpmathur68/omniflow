import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omniflow/screens/loading.dart';

class TaskCubit extends Cubit<TaskCubitState> {
  TaskCubit() : super(TaskCubitInitial());
  loadingScreen(state) {
    emit(TaskCubitLoading());
    Future.delayed(Duration(seconds: 1), () {
      emit(state);
    });
  }
}

class TaskCubitInitial extends TaskCubitState {}

class TaskCubitLoading extends TaskCubitState {}

class TaskCubitState {}

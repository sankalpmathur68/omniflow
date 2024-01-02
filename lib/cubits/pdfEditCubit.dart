import 'package:flutter_bloc/flutter_bloc.dart';

class pdfCubit extends Cubit<pdfCubitState> {
  pdfCubit() : super(pdfInitial()) {
    Future.delayed(Duration(seconds: 1), () {
      emit(pdfRead());
    });
  }
}

class pdfCubitState {}

class pdfInitial extends pdfCubitState {}

class pdfRead extends pdfCubitState {}

// Eventos del Bloc
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/libro.dart';
import '../../domain/repositories/libro_repository.dart';

abstract class LibroEvent extends Equatable {
  const LibroEvent();

  @override
  List<Object?> get props => [];
}

class LoadLibros extends LibroEvent {}

class AddLibro extends LibroEvent {
  final Libro libro;
  AddLibro(this.libro);

  @override
  List<Object?> get props => [libro];
}

class DeleteLibro extends LibroEvent {
  final Libro libro;
  DeleteLibro(this.libro);

  @override
  List<Object?> get props => [libro];
}

// Estado del Bloc
abstract class LibroState extends Equatable {
  const LibroState();

  @override
  List<Object?> get props => [];
}

class LibroInitial extends LibroState {}

class LibroLoading extends LibroState {}

class LibroLoaded extends LibroState {
  final List<Libro> libros;
  LibroLoaded(this.libros);

  @override
  List<Object?> get props => [libros];
}

class LibroError extends LibroState {
  final String message;
  LibroError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class LibroBloc extends Bloc<LibroEvent, LibroState> {
  final LibroRepository repositorio;
  // final repositorio = AppConstants.repo;

  LibroBloc(this.repositorio) : super(LibroInitial()) {
    on<LoadLibros>(_onLoadLibros);
    on<AddLibro>(_onAddLibro);
    on<DeleteLibro>(_onDeleteLibro);
  }

  Future<void> _onLoadLibros(LoadLibros event, Emitter<LibroState> emit) async {
    emit(LibroLoading());
    try {
      final libros = await repositorio.todosLosLibros();
      emit(LibroLoaded(libros));
    } catch (e) {
      emit(LibroError(e.toString()));
    }
  }

  Future<void> _onAddLibro(AddLibro event, Emitter<LibroState> emit) async {
    try {
      await repositorio.addLibro(event.libro);
      final libros = await repositorio.todosLosLibros();
      emit(LibroLoaded(libros));
    } catch (e) {
      emit(LibroError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteLibro(
    DeleteLibro event,
    Emitter<LibroState> emit,
  ) async {
    try {
      repositorio.bajarLibro(event.libro.idLibro!);
      final libros = await repositorio.todosLosLibros();
      emit(LibroLoaded(libros));
    } catch (e) {
      emit(LibroError(e.toString()));
    }
  }
}

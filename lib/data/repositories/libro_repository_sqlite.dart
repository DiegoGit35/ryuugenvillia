import 'package:ryuugenvillia/domain/entities/libro.dart';
import 'package:ryuugenvillia/domain/repositories/libro_repository.dart';

class LibroRepositorySqlite implements LibroRepository{
  @override
  Future<int> addLibro() {
    // TODO: implement addLibro
    throw UnimplementedError();
  }

  @override
  void bajarLibro() {
    // TODO: implement bajarLibro
  }

  @override
  Future<List<Libro>> todosLosLibros() {
    // TODO: implement todosLosLibros
    throw UnimplementedError();
  }

}
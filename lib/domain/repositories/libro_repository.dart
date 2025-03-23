import '../entities/libro.dart';

abstract class LibroRepository {
  Future<List<Libro>> todosLosLibros();
  Future<int> addLibro(Libro nuevoLibro);
  void bajarLibro(int idLibro);
  
}
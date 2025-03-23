import 'package:ryuugenvillia/data/datasources/sqlite_config.dart';
import 'package:ryuugenvillia/domain/entities/libro.dart';
import 'package:ryuugenvillia/domain/repositories/libro_repository.dart';

class LibroRepositorySqlite implements LibroRepository {
  SqliteHelper sqliteHelper = SqliteHelper.instance;
  late int result;
  @override
  Future<int> addLibro(Libro nuevoLibro) async {
    final db = await sqliteHelper.database;
    if (db != null) {
      result = await db.rawInsert(
        'INSERT INTO libro (nombre) '
        'VALUES (?)',
        [nuevoLibro.nombre],
      );
    } else {
      print("No se pudo obtener la instancia de la base de datos.");
    }
    return result;
  }

  @override
  Future<void> bajarLibro(int idLibro) async {
    final db = await sqliteHelper.database;
    if (db != null) {
      result = await db.rawDelete('delete from libro where id = ?', [idLibro]);
    } else {
      print("No se pudo obtener la instancia de la base de datos.");
    }
  }

  @override
  Future<List<Libro>> todosLosLibros() async{
    final db = await sqliteHelper.database;
    List<Map<String, dynamic?>> libros;

    libros = await db!.rawQuery('select * from libro');

    return libros.map((libro) => Libro.fromSqfliteDatabase(libro)).toList();
  }
}

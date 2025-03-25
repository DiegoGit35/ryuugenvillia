import 'package:ryuugenvillia/data/repositories/libro_repository_sqlite.dart';
import 'package:ryuugenvillia/domain/repositories/libro_repository.dart';

class AppConstants {
  static String NOMBRE_DE_LA_APLICACION = "Ryuugenvillia";
  static LibroRepository REPOSITORIO = LibroRepositorySqlite();
}
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ryuugenvillia/data/repositories/libro_repository_sqlite.dart';

import '../entities/libro.dart';

class GetLibros {
  LibroRepositorySqlite repo = LibroRepositorySqlite();
  List<Libro> listaDeLibros = [];

  Future<List<Libro>> getLibrosActivos() async {
    try {
      listaDeLibros = await repo.todosLosLibros();
    } on TimeoutException {
      Fluttertoast.showToast(
                  msg: "Ocurrió un error de timeout",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                 
                  fontSize: 16.0,
                );
    }
      
      return listaDeLibros;
    
  }
}
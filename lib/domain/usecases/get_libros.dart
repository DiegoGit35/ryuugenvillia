import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ryuugenvillia/configuraciones_globales.dart';

import '../entities/libro.dart';
import '../repositories/libro_repository.dart';

class GetLibros {
  LibroRepository repo = AppConstants.REPOSITORIO;
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

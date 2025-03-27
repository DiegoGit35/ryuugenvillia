class Libro {
  late String nombre;
  late int? idLibro;
  // añadir categoria, fecha de creacion, fecha de ultimo acceso?, cantidad de preguntas?, cantidad de veces abierto?, orden de abiertos?
  late List<String> listaPreguntas = [];

  Libro({required this.nombre, this.idLibro});

  factory Libro.fromSqfliteDatabase(Map<String, dynamic> map) {
    return Libro(idLibro: map['id'], nombre: map['nombre'] ?? '',);
  }
}

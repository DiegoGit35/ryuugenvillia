import 'package:flutter/material.dart';
import 'package:ryuugenvillia/domain/entities/libro.dart';
import 'package:ryuugenvillia/domain/usecases/get_libros.dart';
import 'constantes_globales.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: AppConstants.NOMBRE_DE_LA_APLICACION),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GetLibros useCaseGetLibros = GetLibros();
  late Future<List<Libro>> lista = useCaseGetLibros.getLibrosActivos();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.from(alpha: 1, red: 1, green: 1, blue: 1),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: lista,
        builder: (BuildContext context, AsyncSnapshot<List<Libro>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostrar un indicador de carga mientras se espera la respuesta
            return const SizedBox(
              width: 300,
              height: 300,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No hay libros disponibles.");
          } else {
            List<Libro> libros = snapshot.data!;
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: libros.length,
                itemBuilder: (BuildContext context, int index) {
                  Libro unLibro = libros[index];

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: LibroItem(unLibro, context),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

SizedBox LibroItem(Libro unLibro, context) {
  return SizedBox(
    width: 300,
    child: ElevatedButton(
      onPressed: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PagePreguntas(unLibro: unlibro)));
      },
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [Text(unLibro.nombre, style: TextStyle())],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

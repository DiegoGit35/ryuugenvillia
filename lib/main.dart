import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ryuugenvillia/domain/entities/libro.dart';
import 'package:ryuugenvillia/presentation/blocs/lista_de_libros_bloc.dart';
import 'configuraciones_globales.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => LibroBloc(AppConstants.REPOSITORIO)),
        // Agrega otros Blocs aquí
      ],
      child: MaterialApp(
        title: 'Libros App',
        home: MyHomePage(title: AppConstants.NOMBRE_DE_LA_APLICACION),
      ),
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
  @override
  void initState() {
    super.initState();
    context.read<LibroBloc>().add(LoadLibros());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: BlocBuilder<LibroBloc, LibroState>(
        builder: (context, state) {
          if (state is LibroLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LibroLoaded) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.libros.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: LibroItem(state.libros[index], context),
                    ),
                  );
                },
              ),
            );
          } else if (state is LibroError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("No hay libros disponibles."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => agregarLibro(context, context.read<LibroBloc>()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

SizedBox LibroItem(Libro unLibro, context) {
  print("el nombre es ${unLibro.nombre}");
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

void agregarLibro(BuildContext context, LibroBloc bloc) {
  // final paginaController = TextEditingController();
  final nombreController = TextEditingController();
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Agregar un libro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del libro',
                ),
              ),
              // TextField(
              //   controller: paginaController,
              //   decoration: const InputDecoration(labelText: 'pagina de la pregunta'),
              //   keyboardType: TextInputType.number,
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nombre = nombreController.text;
                final libro = Libro(nombre: nombre);
                bloc.add(AddLibro(libro));
                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
  );
}

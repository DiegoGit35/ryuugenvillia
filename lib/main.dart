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
  Libro? libroSeleccionado;

  @override
  void initState() {
    super.initState();
    context.read<LibroBloc>().add(LoadLibros());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          libroSeleccionado = null;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          actions:
              libroSeleccionado != null
                  ? [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        if (libroSeleccionado != null) {
                          context.read<LibroBloc>().add(
                            DeleteLibro(libroSeleccionado!),
                          );
                          setState(() => libroSeleccionado = null);
                        }
                      },
                    ),
                  ]
                  : [],
        ),
        body: BlocBuilder<LibroBloc, LibroState>(
          builder: (context, state) {
            if (state is LibroLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LibroLoaded) {
              return ListView.builder(
                itemCount: state.libros.length,
                itemBuilder: (context, index) {
                  final libro = state.libros[index];
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: LibroItem(libro, context, (libro) {
                        setState(() {
                          libroSeleccionado = libro;
                        });
                      }),
                    ),
                  );
                },
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
      ),
    );
  }
}

SizedBox LibroItem(
  Libro unLibro,
  BuildContext context,
  Function(Libro) onLongPress,
) {
  return SizedBox(
    width: 300,
    child: GestureDetector(
      onLongPress: () {
        onLongPress(unLibro);
      },
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(child: Text(unLibro.nombre)),
        ),
      ),
    ),
  );
}

void agregarLibro(BuildContext context, LibroBloc bloc) {
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ryuugenvillia/main.dart';
import 'package:ryuugenvillia/presentation/pages/preguntas_page.dart';

import 'presentation/blocs/preguntas_bloc.dart';

class RouteGenerator {
  static const String homePage = '/';
  static const String preguntasPage = '/preguntas';
  static const String formPage = '/formulario';

  RouteGenerator._() {}
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (_) => const MyHomePage(title: 'preguntas'),
        );
      case preguntasPage:
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              child: PreguntasPage(),
              create: (_) => PreguntasBloc(""),
            );
          },
        );
      // case formPage:
      //   return MaterialPageRoute(builder: (_) {
      //     return BlocProvider(
      //       child: const FormPage(),
      //       create: (_) => FormCubit(""),
      //     );
      //   });
      default:
        throw FormatException('Route not found');
    }
  }
}

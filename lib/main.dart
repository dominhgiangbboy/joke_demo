import 'package:demo_for_vnext/core/http_client.dart';
import 'package:demo_for_vnext/features/joke_feature/blocs/joke_bloc.dart';
import 'package:demo_for_vnext/features/joke_feature/jokes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  final Dio dio = Dio();
  final HttpClient client = DioClient(dio: dio);
  final JokeBloc bloc = JokeBloc(client);
  runApp(MyApp(
    bloc: bloc,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.bloc});
  final JokeBloc bloc;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: JokesPage(bloc: bloc),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:keskona/repository/ItemRepository.dart';
import 'package:keskona/views/ItemsView.dart';
import 'package:keskona/views/notifiers/ItemViewNotifier.dart';
import 'package:postgres/postgres.dart';

import 'config/db-config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  var getIt = GetIt.instance;

  var dbConnection =
      await rootBundle.loadString("config/app.json").then((value) {
    var config = DBConfig.fromJson(json.decode(value));
    return PostgreSQLConnection(config.host, config.port, config.database,
        username: config.user, password: config.password, useSSL: true);
  });

  getIt.registerSingleton<ItemRepository>(ItemRepository(dbConnection));
  getIt.registerSingleton(ItemViewNotifier());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keskona',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: const ItemsView(),
    );
  }
}
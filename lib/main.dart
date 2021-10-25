import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:diplom/data_source/local/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'ru';
  await LocalStorageApi.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isSplash = true;

  @override
  Widget build(BuildContext context) {
    return
        // MultiBlocProvider(
        //   providers: [
        //     BlocProvider<UserBloc>(
        //       create: (context) => UserBloc(),
        //     ),
        //   ],
        //   child:

        MaterialApp(
      initialRoute: '/',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ru', 'RU'),
      supportedLocales: const [
        Locale('ru', 'RU'),
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: 1,
    );
    // return BlocBuilder<UserBloc, UserState>(
    //   builder: (context, state) {
    //     if (state is UserAuth) {
    //       return MainScreen();
    //     }
    //     if (state is UserEmpty) {
    //       return const LoginScreen();
    //     }
    //     return LoadingWidgets.loadingCenter();
    //   },
    // );
  }
}

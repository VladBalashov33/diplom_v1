import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:diplom/bloc/choose_user_bloc/choose_user_bloc.dart';
import 'package:diplom/data_source/local/local_storage.dart';
import 'package:diplom/screens/choose_user_screen.dart';
import 'package:diplom/utils/theme.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChooseUserBloc>(
          create: (context) => ChooseUserBloc(),
        ),
      ],
      child: MaterialApp(
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
        theme: myTheme,
        home: LoadingScreen(),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ChooseUserScreen();
  }
}

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';

import 'app_localizations.dart';
import 'custom_asset_bundle.dart';
import 'data/datasources/currencies_datasource.dart';
import 'data/datasources/entities/currency_entity.dart';
import 'data/datasources/entities/project_entity.dart';
import 'data/datasources/entities/user_entity.dart';
import 'data/datasources/entities/user_expense_entity.dart';
import 'injection.dart';
import 'presentation/bloc/bloc.dart';
import 'presentation/widgets/pages/projects_list_page.dart';

const supportedCurrencies = ['USD', 'EUR', 'PLN', 'GBP'];

Future<void> main() async {
  await initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  services.SystemChrome.setPreferredOrientations([
    services.DeviceOrientation.portraitUp,
    services.DeviceOrientation.portraitDown
  ]).then((_) {
    runApp(DevicePreview(
      enabled: false,
      builder: (context) => DefaultAssetBundle(
        bundle: CustomAssetBundle(),
        child: MyApp(),
      ),
    ));
  });
}

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(Env.prod);
  await Hive.initFlutter();
  Hive.registerAdapter(CurrencyEntityAdapter());
  Hive.registerAdapter(ProjectEntityAdapter());
  Hive.registerAdapter(UserEntityAdapter());
  Hive.registerAdapter(UserExpenseEntityAdapter());
  await _initHiveStaticData();
}

Future<void> _initHiveStaticData() async {
  final currenciesDataSource = ic<CurrenciesDataSource>();
  final currencies = await currenciesDataSource.getCurrencies();
  if (currencies.isEmpty) {
    await currenciesDataSource.saveCurrencies(supportedCurrencies);
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ProjectBloc>(
            create: (BuildContext context) => ic<ProjectBloc>(),
          ),
          BlocProvider<CurrencyBloc>(
            create: (BuildContext context) => ic<CurrencyBloc>(),
          ),
          BlocProvider<UserBloc>(
            create: (BuildContext context) => ic<UserBloc>(),
          ),
          BlocProvider<ExpenseBloc>(
            create: (BuildContext context) => ic<ExpenseBloc>(),
          ),
          BlocProvider<ReportBloc>(
            create: (BuildContext context) => ic<ReportBloc>(),
          ),
        ],
        child: OKToast(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.of(context).locale,
            builder: DevicePreview.appBuilder,
            title: 'Costy',
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('pl', 'PL'),
            ],
            // These delegates make sure that the localization data for the proper language is loaded
            localizationsDelegates: const [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
            ],
            // Returns a locale which will be used by the app
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              // If the locale of the device is not supported, use the first one
              // from the list (English, in this case).
              return supportedLocales.first;
            },
            home: ProjectsListPage(),
          ),
        ));
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

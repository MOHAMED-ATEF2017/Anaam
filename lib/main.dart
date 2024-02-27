import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:en3am_app/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/bank_accounts/banks_bloc.dart';
import 'bloc/chat/chat_bloc.dart';
import 'bloc/cities/cities_bloc.dart';
import 'bloc/cutting/cutting_bloc.dart';
import 'bloc/internet_check/internet_check_bloc.dart';
import 'bloc/minced/minced_bloc.dart';
import 'bloc/orders/orders_bloc.dart';
import 'bloc/packaging/packaging_bloc.dart';
import 'bloc/settings/settings_bloc.dart';
import 'bloc/times/times_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'config/Notifications/NotifictaionsSettings.dart';
import 'config/lang/localization/center_localization.dart';
import 'config/lang/localization/localization_values.dart';
import 'config/theme_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  NotificationsSettings notifications = NotificationsSettings();
  notifications.FirebaseInit();
  notifications.localInit();
      final prefs = await SharedPreferences.getInstance();
    const key5 = 'token';

    debugPrint("TOKEN               ${prefs.getString(key5)}");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext buildContext, Locale locale) {
    _MyAppState? state = buildContext.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar', '');

  final String defaultLocale = Platform.localeName;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<InternetCheckBloc>(
            create: (context) => InternetCheckBloc(),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(),
          ),
          BlocProvider<CuttingBloc>(
            create: (context) => CuttingBloc(),
          ),
          BlocProvider<PackagingBloc>(
            create: (context) => PackagingBloc(),
          ),
          BlocProvider<CitiesBloc>(
            create: (context) => CitiesBloc(),
          ),
          BlocProvider<BanksBloc>(
            create: (context) => BanksBloc(),
          ),
          BlocProvider<TimesBloc>(
            create: (context) => TimesBloc(),
          ),
          BlocProvider<OrdersBloc>(
            create: (context) => OrdersBloc(),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(),
          ),
          BlocProvider<MincedBloc>(
            create: (context) => MincedBloc(),
          ),
        ],
        child: BlocConsumer<InternetCheckBloc, InternetCheckState>(
          listener: (context, state) {
            // if (state is NotConnectedState) {
            //   Navigator.push(context, MaterialPageRoute(builder: (_) => const NoInternet()));
            // }
          },
          builder: (context, state) {
            return MaterialApp(
              locale: _locale,
              supportedLocales: const [
                Locale('ar', ''),
                Locale('en', 'US'),
              ],
              localizationsDelegates: const [
                CenterLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale?.languageCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              debugShowCheckedModeBanner: false,
              title: 'أنعام بيشة',
              theme: appTheme,
              home: const Splash(),
            );
          },
        ));
  }
}

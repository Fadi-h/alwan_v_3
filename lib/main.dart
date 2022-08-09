import 'package:alwan_v_3/app_localization.dart';
import 'package:alwan_v_3/helper/global.dart';
import 'package:alwan_v_3/helper/myTheme.dart';
import 'package:alwan_v_3/helper/store.dart';
import 'package:alwan_v_3/view/address_2.dart';
import 'package:alwan_v_3/view/intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';




const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_important_channel',
   'important notification',
  importance: Importance.high,
  playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification!;
    AndroidNotification android = message.notification!.android!;
    if(notification != null && android != null){
      flutterLocalNotificationsPlugin.show(
      notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.high,
              color: Colors.red,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ));
    }
  });


  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
    RemoteNotification notification = message.notification!;
    AndroidNotification android = message.notification!.android!;
    if(notification != null && android != null){
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.red,
              importance: Importance.high,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ));
    }
  });



  runApp( MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: MyTheme.isDarkTheme.value ? Colors.black : Colors.white,
  ));
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);


  static void set_local(BuildContext context , Locale locale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.set_locale(locale);
  }

  static void setTheme(BuildContext context){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setDark();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale? _locale;
  Rx<MyTheme> myTheme = MyTheme().obs;

  void set_locale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }

  @override
  void initState() {
    Store.loadTheme().then((value) {
      MyTheme.isDarkTheme.value = !value;
    });
    Global.loadLanguage().then((language) {
      setState(() {
        _locale= Locale(language);
      });
    });
    super.initState();
  }

  void setDark(){
    setState(() {
      myTheme.value.myTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: myTheme.value.myTheme,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
        locale: _locale,
        supportedLocales: [Locale('en', ''), Locale('ar', '')],
        localizationsDelegates: const [
          App_Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (local, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == local!.languageCode) {
              Global.langCode = supportedLocale.languageCode;
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      home: Intro()
      // home: Addresses_2()
    );
  }
}

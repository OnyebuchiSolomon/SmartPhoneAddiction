import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_phone_addiction/provider/apps_provider.dart';
import 'package:smart_phone_addiction/provider/setting_provider.dart';
import 'package:smart_phone_addiction/provider/whit_list_provider.dart';
import 'package:smart_phone_addiction/service/background_service.dart';
import 'package:smart_phone_addiction/ui/home%20page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if(value){
      Permission.notification.request();
    }
  });
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppsProvider()),
        ChangeNotifierProvider(create: (_) => WhiteListProvider()),
        ChangeNotifierProvider(create: (_) => Settings()),
        // ChangeNotifierProxyProvider<AppsProvider, WhiteListProvider>(
        //   create: (_) => WhiteListProvider(Provider.of<AppsProvider>(_)),
        //   update: (_, AppsProvider, WhiteListProvider) =>
        //   WhiteListProvider!.._appsProvider = AppsProvider,
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
              .copyWith(background: Colors.white),
        ),
        home: const MyHomePage(title: 'TODAY'),
      ),
    );
  }
}

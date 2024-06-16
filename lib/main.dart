import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prectical_exam/auth_provider.dart';
import 'package:prectical_exam/file_provider.dart';
import 'package:prectical_exam/firebase_options.dart';
import 'package:prectical_exam/home.dart';
import 'package:prectical_exam/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
Stripe.urlScheme = 'flutterstripe';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();
  await Stripe.instance.applySettings();
  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(create: (_) => ImageProviders()),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // For Material Components theme
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        
        buttonTheme: const ButtonThemeData(),
        textTheme: const TextTheme(),
      ),
      home: firebaseUser == null ? const LoginPage() : const Home(),
    );
  }
}

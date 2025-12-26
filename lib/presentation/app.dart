import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/client_provider.dart';
import '../providers/interaction_provider.dart';
import '../injection.dart';
import '../screens/splash_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ClientProvider>()),
        ChangeNotifierProvider(create: (_) => sl<InteractionProvider>()),
      ],
      child: MaterialApp(
        title: 'Field Sales CRM',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/client-list': (context) => const ClientListScreen(),
        },
      ),
    );
  }
}
import 'package:field_sales_crm/presentation/screens/auth/login_screen.dart';
import 'package:field_sales_crm/presentation/screens/auth/signup_screen.dart';
import 'package:field_sales_crm/presentation/screens/client/client_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/client_provider.dart';
import 'providers/interaction_provider.dart';
import '../injection.dart' as di;
import 'screens/splash_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ClientProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<InteractionProvider>()),
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
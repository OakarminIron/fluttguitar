import 'package:flutter/material.dart';
import 'route.dart';
import 'package:provider/provider.dart';
import './Model/dummyproducts.dart';
import './Model/cart.dart';
import './Model/checkout.dart';
import './Model/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build( context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Dummyproducts(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),

       /* ChangeNotifierProvider<Auth>(create: (_) => Auth()),
 

        ChangeNotifierProxyProvider<Auth, Checkout>(
          create: (BuildContext context) => Checkout(
            (Provider.of<Auth>(context, listen: false)),
            (Provider.of<Auth>(context, listen: false)),
            (Provider.of<Auth>(context, listen: false)),
          ),
          update: (ctx, auth, previousOrders) => Checkout(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.checkout,
          ),
        ),
        */
      ],
      child: MaterialApp(
        title: 'Guitar Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          primaryColor: const Color(0xFF109099),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: appRoutes,
        initialRoute: '/overview',
      ),
    );
  }
}

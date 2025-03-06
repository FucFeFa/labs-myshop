import 'package:flutter/material.dart';
import 'package:myshop/ui/products/edit_product_screen.dart';
import 'package:myshop/ui/products/products_overview_screen.dart';
import 'package:myshop/ui/screens.dart';
import 'package:provider/provider.dart';
import 'ui/products/products_manager.dart';
import 'ui/products/product_detail_screen.dart';
import 'ui/products/products_overview_screen.dart';
import 'ui/products/user_products_screen.dart';
import 'ui/cart/cart_screen.dart';
import 'ui/orders/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.purple,
      secondary: Colors.deepOrange,
      surface: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProductsManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersManager(),
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          return MaterialApp(
            title: 'MyShop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: colorScheme,
              appBarTheme: AppBarTheme(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shadowColor: colorScheme.shadow,
                elevation: 4,
              ),
          
              //Add a dialogTheme definition to ThemeData
              dialogTheme: DialogTheme(
                titleTextStyle: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
          
                contentTextStyle: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 20,
                ),
              )
          
            ),
            home: authManager.isAuth
                ? const SafeArea(child: ProductsOverviewScreen())
                : FutureBuilder(
                    future: authManager.tryAutoLogin(), 
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SafeArea(child: SplashScreen())
                          : const SafeArea(child: AuthScreen());
                    },
                  ),
            routes: {
              CartScreen.routeName: (ctx) => const SafeArea(
                child: CartScreen(),
              ),
              OrdersScreen.routeName: (ctx) => const SafeArea(
                child: OrdersScreen(),
              ),
              UserProductsScreen.routeName: (ctx) => SafeArea(
                child: UserProductsScreen(),
              )
            },
          
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child: ProductDetailScreen(
                        product: ProductsManager().findById(productId)!,
                      ),
                    );
                  }
                );
              }
              if(settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return SafeArea(
                      child: EditProductScreen(
                        productId != null
                            ? ctx.read<ProductsManager>().findById(productId)
                            : null,
                      ),
                    );
                  }
                );
              }
              return null;
            },
          );
        }
      ),
    );
  }
}

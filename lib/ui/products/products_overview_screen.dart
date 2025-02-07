import 'package:flutter/material.dart';
import 'products_grid.dart';
import '../cart/cart_screen.dart';
import '../shared/app_drawer.dart';
import '../cart/cart_manager.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() =>
      _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _currentFilter = FilterOptions.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          ProductFilterMenu(
            currentFilter: _currentFilter,
            onFilterSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
          ),
          ShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(
        _currentFilter == FilterOptions.favorites,
      ),
    );
  }
}

class ProductFilterMenu extends StatelessWidget {
  const ProductFilterMenu({
      super.key,
      this.currentFilter,
      this.onFilterSelected,
  });

  final FilterOptions? currentFilter;
  final void Function(FilterOptions selectedValue)? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: currentFilter,
      onSelected: onFilterSelected,
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    ); // Add your implementation here
  }
}

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Badge.count(
        count: CartManager().productCount,
        child: const Icon(
          Icons.shopping_cart,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

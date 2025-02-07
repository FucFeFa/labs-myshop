import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../products/products_overview_screen.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail';
  const ProductDetailScreen({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ProductsOverviewScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                '\$${product.price}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Text(
                    "Quantity:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: 1,
                    items: List.generate(
                      10,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text("${index + 1}"),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Text(
                    "Size:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: "M",
                    items: const [
                      DropdownMenuItem(value: "S", child: Text("Small (S)")),
                      DropdownMenuItem(value: "M", child: Text("Medium (M)")),
                      DropdownMenuItem(value: "L", child: Text("Large (L)")),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

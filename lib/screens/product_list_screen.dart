import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<dynamic>> products;
  List<dynamic> filteredProducts = [];
  List<dynamic> favoriteProducts = [];
  String searchQuery = '';
  bool showFavorites = false;
  String? popupMessage;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products?limit=26'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  void filterProducts(List<dynamic> allProducts, String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts = allProducts.where((product) =>
          product['title'].toLowerCase().contains(searchQuery)).toList();
    });
  }

  void toggleFavorite(dynamic product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
        showPopupMessage('Removed from favorites');
      } else {
        favoriteProducts.add(product);
        showPopupMessage('Added to favorites');
      }
    });
  }

  void showPopupMessage(String message) {
    setState(() {
      popupMessage = message;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        popupMessage = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartio', style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 40.0,
            color: Colors.white)),
        backgroundColor: Colors.cyan.shade700,
        actions: [
          IconButton(
            icon: Icon(
              showFavorites ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showFavorites = !showFavorites;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load products 😞'));
              } else {
                if (showFavorites) {
                  filteredProducts = favoriteProducts;
                } else {
                  filteredProducts = searchQuery.isEmpty
                      ? snapshot.data!
                      : snapshot.data!.where((product) =>
                      product['title'].toLowerCase().contains(searchQuery))
                      .toList();
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: isDesktop ? 400 : double.infinity,
                          child: TextField(
                            onChanged: (query) => filterProducts(snapshot.data!, query),
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: (showFavorites && favoriteProducts.isEmpty)
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 60, color: Colors.grey.shade600),
                            const SizedBox(height: 10),
                            const Text(
                              'No favorites found',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                          : (filteredProducts.isEmpty && searchQuery.isNotEmpty)
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 60, color: Colors.grey.shade600),
                            const SizedBox(height: 10),
                            const Text(
                              'No search results found',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                          : GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 3 : 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: isDesktop ? 0.65 : 0.7,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onFavoriteToggle: (isFav) {
                              toggleFavorite(product);
                            },
                            isFavorite: favoriteProducts.contains(product),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          if (popupMessage != null)
            Positioned(
              top: kToolbarHeight + 10,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  popupMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

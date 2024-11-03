import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final dynamic product;
  final Function(bool) onFavoriteToggle;
  final bool isFavorite;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: isHovered ? Matrix4.identity() * 0.97 : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border.all(
            color: Color(0xFF005960),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: Colors.black54,
                blurRadius: 12.0,
                offset: Offset(0, 6),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.product['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: isHovered ? Colors.black.withOpacity(0.3) : Colors.transparent,
                    ),
                    Positioned(
                      right: 8.0,
                      top: 8.0,
                      child: GestureDetector(
                        onTap: () {
                          widget.onFavoriteToggle(!widget.isFavorite);
                        },
                        child: Icon(
                          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: widget.isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Price: \$${widget.product['price']}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.0,
                        color: Color(0xFFFF6B6B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Category: ${widget.product['category']}',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 12.0,
                        color: Color(0xFF6E6E6E),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16.0, color: Colors.amber),
                        const SizedBox(width: 4.0),
                        Text(
                          widget.product['rating']['rate'].toString(),
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontFamily: "Lato",
                            color: Color(0xFF005960),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

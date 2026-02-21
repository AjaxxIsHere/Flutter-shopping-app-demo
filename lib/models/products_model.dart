// Product model representing the structure of a single product data from the API
// Fields: - id: unique identifier for the product
//         - title: name of the product
//         - price: cost of the product
//         - image: URL to the product image
//         - description: detailed information about the product
//         - rating: average user rating for the product
// Methods: - fromJson: factory constructor to create a Product instance from JSON data
//          - toJson: method to convert a Product instance back to JSON format (useful for cart storage)
class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description, 
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(), 
      image: json['image'],
      description: json['description'], 
      rating: json['rating'] != null ? (json['rating']['rate'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'description': description,
      'rating': rating,
    };
  }
}
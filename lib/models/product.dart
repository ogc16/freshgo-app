class Product {
  final int id;
  final String name;
  final String unit;
  final int price;
  final String emoji;
  final String imageUrl;
  final String? localImage;
  final String tag;
  final String tagColor;
  final String tagTxt;
  final String bg;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    required this.emoji,
    required this.imageUrl,
    this.localImage,
    required this.tag,
    required this.tagColor,
    required this.tagTxt,
    required this.bg,
    required this.category,
  });

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'] as int,
    name: map['name'] as String? ?? '',
    unit: map['unit'] as String? ?? '',
    price: map['price'] as int? ?? 0,
    emoji: map['emoji'] as String? ?? '\u{1F4E6}',
    imageUrl: map['image_url'] as String? ?? '',
    tag: map['tag'] as String? ?? '',
    tagColor: map['tag_color'] as String? ?? '#E8F5EC',
    tagTxt: map['tag_txt'] as String? ?? '#1C5C35',
    bg: map['bg'] as String? ?? '#FFFFFF',
    category: map['category'] as String? ?? 'groceries',
  );
}

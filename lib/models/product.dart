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
  });
}
